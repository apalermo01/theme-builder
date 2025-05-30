import argparse
import json
import logging
import os
import shutil
import stat
import subprocess
from datetime import datetime
from typing import Dict, List

import yaml

from modules import modules
from modules.utils import configure_colors, validate_config

logger = logging.getLogger(__name__)
logging.basicConfig(level=logging.INFO)

ORDER: List = [
    "colors",
    "apps",
    "i3",
    "hyprland",
    "polybar",
    "waybar",
    "wallpaper",
    "nvim",
    "tmux",
    "rofi",
    "picom",
    "fish",
    "bash",
    "zsh",
    "kitty",
    "alacritty",
    "fastfetch",
    "okular",
    "yazi",
]


def init_script() -> str:
    return "#!/usr/bin/env bash\n\n"


def get_theme_config(theme_path: str) -> Dict:
    """Load the config file for the selected theme, allow for different file types"""

    all_files: List = os.listdir(theme_path)
    for f in all_files:
        if "theme" in f:
            extension: str = f.split(".")[1]

            if extension == "json":
                ftype: str = "json"

            elif extension in ["yml", "yaml"]:
                ftype: str = "yaml"

            else:
                raise ValueError(
                    f"Invalid extension for {f}, must be json, yaml, or yml"
                )

            with open(os.path.join(theme_path, f), "r") as f:
                if ftype == "json":
                    config: Dict = json.load(f)
                else:
                    config: Dict = yaml.safe_load(f)

            return config

    raise ValueError("theme file not found!")


def build_theme(theme_name: str, test: bool, orient: str):
    """Generate a set of dotfiles and cache it in the build directory.
    theme_name: str - name of the selected theme. Must be present in ./themes/
    test:
        true: searches for themes in the 'tests' directory
        false: searches for themes in the 'themes' directory
    orient:
    """

    # where to search for the theme name
    if test:
        theme_path: str = os.path.join("tests", theme_name)
    else:
        theme_path: str = os.path.join("themes", theme_name)

    # load and validate the config
    config: Dict = get_theme_config(theme_path)

    res, config = validate_config(config, theme_path)

    if not res:
        raise ValueError("Invalid configuration!")

    # configure where the cached config files should live
    # remove an old version of it if it already exists
    destination_base: str = os.path.join(theme_path, "build")

    if os.path.exists(destination_base):
        shutil.rmtree(destination_base)
        logger.debug(f"removed directory {destination_base}")

    os.makedirs(destination_base)
    os.makedirs(os.path.join(destination_base, "global"))
    logger.debug(f"created directory {destination_base}")

    # load config file specifying paths for each tool
    with open("./configs/paths.yaml", "r") as f:
        path_config: Dict = yaml.safe_load(f)

    loglen = 8 + 2 + len("BUILDING THEME") + 1 + len(theme_name)
    logger.info("=" * loglen)
    logger.info(f"==== BUILDING THEME {theme_name} ====")
    logger.info("=" * loglen)

    # set up a dictionary with info on updated tools
    tools_updated: Dict = {}

    # start building the script to install the script
    theme_apply_script: str = init_script()

    # now loop through all the tools
    destination_path: str = os.path.join(
        destination_base, path_config["global"]["destination_path"]
    )
    config, theme_apply_script = modules["global"](
        config=config,
        template_dir=path_config["global"]["template_path"],
        theme_path=theme_path,
        orient=orient,
        destination_dir=destination_path,
        theme_apply_script=theme_apply_script,
    )
    tools_updated["global"] = {"destination_dir": destination_path}
    for key in ORDER:
        if key in config:

            logger.debug(f"processing key {key}")

            # set where the files should be written to
            # ex: themes/theme_name/build/.config/tool_name
            #                             ^^^^^^^^^^^^^^^^^
            #                             This is destination_path
            destination_path: str = os.path.join(
                destination_base, path_config[key]["destination_path"]
            )

            # by default, the template configs live in
            # project_root/default_configs/toolname/...
            if "template_path" in config[key]:
                template_path: str = config[key]["template_path"]
            else:
                template_path: str = path_config[key]["template_path"]

            # Build the theme
            config, theme_apply_script = modules[key](
                template_dir=template_path,
                destination_dir=destination_path,
                config=config,
                theme_path=theme_path,
                orient=orient,
                theme_apply_script=theme_apply_script,
            )

            tools_updated[key] = {"destination_dir": destination_path}

    # configure templated colors
    configure_colors(theme_path)

    # take all the lines that each module wrote for the installer and write them
    # to a script
    install_script_path = os.path.join(destination_base, "install_theme.sh")
    with open(install_script_path, "w") as f:
        f.write(theme_apply_script)

    return tools_updated, theme_path, config


def copy_theme(*args, **kwargs):
    logger.error("Directly copying themes is not supported (yet?)")


def move_to_dotfiles(
    tools,
    config,
    orient,
    theme_name,
    dotfiles_path,
):
    loglen = 8 + 2 + len("COPYING THEME TO DOTFILES:") + 1 + len(theme_name)
    logger.info("=" * loglen)
    logger.info(f"==== COPYING THEME TO DOTFILES: {theme_name} ====")
    logger.info("=" * loglen)

    with open("./configs/paths.yaml", "r") as f:
        path_config = yaml.safe_load(f)

    original_dir = os.getcwd()
    dotfiles_theme_path = os.path.join(dotfiles_path, theme_name)
    if "git" not in dotfiles_theme_path or len(dotfiles_theme_path) < 8:
        raise ValueError(
            f"'git' is not in the dotfiles path OR the path is "
            + "less than 8 characters. While not a bug, this is "
            + "suspicious, so I'm crashing. To fix this, just "
            + "put the dotfiles retool in a folder called 'git'"
        )

    if os.path.exists(dotfiles_theme_path):
        logger.debug(f"removing {dotfiles_theme_path}")
        shutil.rmtree(dotfiles_theme_path)

    os.makedirs(dotfiles_theme_path)

    # deal with global settings
    if 'wsl' not in theme_name:
        profile_src = os.path.join(
            "./", tools['global']['destination_dir'], ".profile"
        )
        profile_dst = os.path.join(
            dotfiles_theme_path, 'profile'
        )
        shutil.copy2(profile_src, profile_dst)
        logger.info(f"{profile_src} -> {profile_dst}")
    for t in tools:
        logger.info(f"processing {t}...")

        if t in ["colors", "wallpaper"]:
            continue

        # check how we're structuring the destination path
        if orient == "roles":
            destination_path = os.path.join(dotfiles_theme_path, t)
            sub_path = t

        else:
            destination_path = os.path.join(
                dotfiles_theme_path, path_config[t].get("config_path", "")
            )
            sub_path = path_config[t]["config_path"]

        # get the source path
        source_path = tools[t]["destination_dir"]

        # make backup
        if len(sub_path) > 0:
            logger.debug("sub path is not empty")
            logger.debug(f"{source_path} -> {destination_path}")
            shutil.copytree(source_path, destination_path, dirs_exist_ok=True)

        else:
            logger.debug("looping through files in ", source_path)
            for file in os.listdir(source_path):
                src = os.path.join(source_path, file)
                dest = os.path.join(destination_path, file)
                logger.debug(f"{src} -> {dest}")
                shutil.copy2(src, dest)

    # copy the install script to the cache
    scripts_src = os.path.join("themes", theme_name, "build", "install_theme.sh")
    scripts_dest = os.path.join(dotfiles_theme_path, ".config", "install_theme.sh")
    logger.info(f"{scripts_src} -> {scripts_dest}")
    shutil.copy2(scripts_src, scripts_dest)
    logger.info(f"{scripts_src} -> {scripts_dest}")

    # append any additional theme scripts
    if "theme_scripts" in config:
        source_path: str = config["theme_scripts"].get(
            "path", f"./themes/{theme_name}/scripts/"
        )
        for file in os.listdir(source_path):
            source_file: str = os.path.join(source_path, file)
            with open(source_file, "r") as src, open(scripts_dest, "a") as dst:
                for line in src.readlines():
                    if line.startswith("#!/"):
                        continue
                    dst.write(line)

    os.chmod(
        scripts_dest,
        os.stat(scripts_dest).st_mode | stat.S_IEXEC,
    )

    os.chdir(dotfiles_path)
    date = datetime.now().strftime("%Y-%m-%d")
    subprocess.run(
        [
            "git",
            "add",
            ".",
        ]
    )
    subprocess.run(["git", "commit", "-m", f"theme builder - {date} - {theme_name}"])


def parse_args():
    parser = argparse.ArgumentParser()
    parser.add_argument("--theme")
    parser.add_argument("--test", default=True, action=argparse.BooleanOptionalAction)

    parser.add_argument(
        "--migration-method", default="none", choices=["none", "copy", "dotfiles"]
    )

    parser.add_argument("--dotfiles-path", default="/home/alex/Documents/git/dotfiles/")

    parser.add_argument("--destination-root", default="")

    parser.add_argument(
        "--make-backup", default=True, action=argparse.BooleanOptionalAction
    )

    parser.add_argument(
        "--destination-structure", default="roles", choices=["roles", "config", "stow"]
    )

    args = parser.parse_args()
    return args


def main():
    args = parse_args()
    theme_name = args.theme
    tools_updated, theme_path, config = build_theme(
        theme_name,
        args.test,
        args.destination_structure,
    )

    if args.migration_method == "none":
        return

    if args.migration_method == "copy":
        copy_theme(
            tools_updated,
            theme_path,
            args.make_backup,
            args.destination_root,
            args.destination_structure,
            config,
            args.nvim_only,
        )

    if args.migration_method == "dotfiles":
        move_to_dotfiles(
            tools_updated,
            config,
            args.destination_structure,
            theme_name,
            args.dotfiles_path,
        )


if __name__ == "__main__":
    main()
