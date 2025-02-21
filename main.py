import argparse
import json
import logging
import os
import shutil
import subprocess
from datetime import datetime
from typing import Literal

import yaml

from modules import modules
from modules.scripts import parse_scripts
from modules.utils import configure_colors, validate_config

logger = logging.getLogger(__name__)
logging.basicConfig(level=logging.INFO)

def get_theme_config(theme_path: str) -> dict:
    all_files = os.listdir(theme_path)
    for f in all_files:
        if "theme" in f:
            extension = f.split(".")[1]

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
                    config: dict = json.load(f)
                else:
                    config: dict = yaml.safe_load(f)

            return config

    raise ValueError("theme file not found!")


def build_theme(theme_name: str, test: bool, orient: str):

    if test:
        theme_path: str = os.path.join("tests", theme_name)
    else:
        theme_path: str = os.path.join("themes", theme_name)

    config = get_theme_config(theme_path)

    res, config = validate_config(config, theme_path)
    if not res:
        raise ValueError("Invalid configuration!")

    destination_base = os.path.join(theme_path, "build")
    if os.path.exists(destination_base):
        shutil.rmtree(destination_base)
        logger.info(f"removed directory {destination_base}")

    os.makedirs(destination_base)
    logger.info(f"created directory {destination_base}")

    ### get path config
    ### TODO: make this configurable
    with open("./configs/paths.yaml", "r") as f:
        path_config = yaml.safe_load(f)

    logger.info("=========== BUILDING THEME ===========")

    tools_updated = {}
    order = [
        "colors",
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
        "kitty",
        "alacritty",
        "fastfetch"
    ]
    for key in order:
        if key in config:
            logger.info(f"processing {key}")

            destination_path = os.path.join(
                destination_base, path_config[key]["destination_path"]
            )
            if "template_path" in config[key]:
                template_path = config[key]["template_path"]
            else:
                template_path = path_config[key]["template_path"]

            config = modules[key](
                template_dir=template_path,
                destination_dir=destination_path,
                config=config,
                theme_path=theme_path,
                orient=orient,
            )

            tools_updated[key] = {"destination_dir": destination_path}

    configure_colors(theme_path)
    return tools_updated, theme_path, config


def copy_theme(
    tools: dict,
    theme_path: str,
    make_backup: bool,
    destination_root: str,
    orient: Literal["roles", "config"],
    config: dict,
):
    """
    tools: dictionary of tools that have been updated
    theme_path: path to the theme that was just built
    make_backup: whether or not to make a backup folder
    destination_root: 'HOME' or path to where dotfiles should live
    orient: how to structure the theme file.

    roles:
    /path/to/dotfiles/
    ├─ i3/
    │  ├─ config
    ├─ tmux/
    │  ├─ tmux.conf

    config:

    home/username/
    ├─ .config/
    │  ├─ i3/
    │  │  ├─ config
    ├─ .tmux.conf

    """
    print("==========================")
    print("=== COPYING THEME ========")
    print("==========================")

    ### TODO: allow custom path configs
    with open("./configs/paths.yaml", "r") as f:
        path_config = yaml.safe_load(f)

    if orient not in ["roles", "config"]:
        raise ValueError()

    if make_backup:
        backup_id = datetime.now().strftime("%Y-%m-%d::%X")
        backup_root = os.path.join(destination_root, "dotfiles_backups", backup_id)
    else:
        backup_root = None

    for t in tools:
        print("processing", t)

        # TODO: abstract out list of roles / tools to skip
        if t in ["colors", "wallpaper"]:
            continue

        # check how we're structuring the destination path
        if orient == "roles":
            destination_path = os.path.join(destination_root, t)
            sub_path = t

        else:
            destination_path = os.path.join(
                destination_root, path_config[t].get("config_path", "")
            )
            sub_path = path_config[t]["config_path"]

        # get the source path
        source_path = tools[t]["destination_dir"]

        # make backup
        if len(sub_path) > 0:
            print("sub path is not empty")
            if make_backup and os.path.exists(destination_path) and len(sub_path) > 0:
                if not backup_root:
                    raise ValueError("Expected backup_root to be non-null")
                if not os.path.exists(backup_root):
                    os.makedirs(backup_root)
                backup_path = os.path.join(backup_root, sub_path)

                print(f"backing up {destination_path} to {backup_path}")
                shutil.copytree(destination_path, backup_path)

            # move the files
            if os.path.exists(destination_path):
                shutil.rmtree(destination_path)

            print(f"moving {source_path} to {destination_path}")
            shutil.copytree(source_path, destination_path)

        else:
            print("looping through files in ", source_path)
            for file in os.listdir(source_path):
                if make_backup and os.path.exists(os.path.join(destination_path, file)):
                    if not backup_root:
                        raise ValueError("Expected backup_root to be non-null")
                    if not os.path.exists(backup_root):
                        os.makedirs(backup_root)

                    logger.info(
                        f"backing up {os.path.join(destination_path, file)} to {os.path.join(backup_root, file)}"
                    )
                    shutil.copy2(
                        os.path.join(destination_path, file),
                        os.path.join(backup_root, file),
                    )

                logger.info(
                    f"copying {os.path.join(source_path, file)} to {os.path.join(destination_path, file)}"
                )
                shutil.copy2(
                    os.path.join(source_path, file),
                    os.path.join(destination_path, file),
                )

    if "scripts" in config:
        root = destination_root
        if orient == "roles":
            root = os.path.join(root, "scripts")
        parse_scripts(config, root)

    if "theme_scripts" in config:
        path = config["theme_scripts"]["path"]
        for file in os.listdir(path):
            subprocess.call(os.path.join(path, file))


def parse_args():
    parser = argparse.ArgumentParser()
    parser.add_argument("--theme")
    parser.add_argument("--test", default=True, action=argparse.BooleanOptionalAction)

    parser.add_argument("--migration-method", default="none", choices=["none", "copy"])

    parser.add_argument("--destination-root", default="")

    parser.add_argument(
        "--make-backup", default=True, action=argparse.BooleanOptionalAction
    )

    parser.add_argument(
        "--destination-structure", default="roles", choices=["roles", "config"]
    )

    args = parser.parse_args()
    return args


def main():
    args = parse_args()
    theme_name = args.theme
    tools_updated, theme_path, config = build_theme(
        theme_name, args.test, args.destination_structure
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
        )


if __name__ == "__main__":
    main()
    
