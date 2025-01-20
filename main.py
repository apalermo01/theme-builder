import argparse
import logging
import os
import shutil
<<<<<<< HEAD
=======
import subprocess
from typing import Dict
from pathlib import Path 
>>>>>>> 21ce9e2c7caa6d0dec3dc2f90d3e20aa24920b30
from datetime import datetime
from typing import Literal
import json

<<<<<<< HEAD
import yaml

from modules import modules
from modules.utils import configure_colors, validate_config
=======
from modules.alacritty import parse_alacritty
from modules.bash import parse_bash
from modules.colors import parse_colors
from modules.fish import parse_fish
from modules.hyprland import parse_hyprland
from modules.i3 import parse_i3
from modules.kitty import parse_kitty
from modules.nvim import parse_nvim
from modules.picom import parse_picom
from modules.polybar import parse_polybar   
from modules.rofi import parse_rofi
from modules.tmux import parse_tmux
from modules.utils import validate_config
from modules.wallpaper import parse_wallpaper
from modules.waybar import parse_waybar
from modules.fastfetch import parse_fastfetch
>>>>>>> 21ce9e2c7caa6d0dec3dc2f90d3e20aa24920b30

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

<<<<<<< HEAD
            with open(os.path.join(theme_path, f), "r") as f:
                if ftype == "json":
                    config: dict = json.load(f)
                else:
                    config: dict = yaml.safe_load(f)

            return config

    raise ValueError("theme file not found!")


def build_theme(theme_name: str, test: bool):

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

    logger.info("======================================")
    logger.info("=========== BUILDING THEME ===========")
    logger.info("======================================")

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
            )

            tools_updated[key] = {"destination_dir": destination_path}

    configure_colors(theme_path)
    return tools_updated, theme_path


def copy_theme(
    tools: dict,
    theme_path: str,
    make_backup: bool,
    destination_root: str,
    orient: Literal["roles", "config"],
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

    ### TODO: allow custom path configs
    with open("./configs/paths.yaml", "r") as f:
        path_config = yaml.safe_load(f)

    if orient not in ["roles", "config"]:
        raise ValueError()

    if make_backup:
        backup_id = datetime.now().strftime("%Y-%m-%d::%X")
        backup_root = os.path.join(destination_root, "dotfiles_backups", backup_id)

    for t in tools:
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
            if make_backup and os.path.exists(destination_path) and len(sub_path) > 0:
                if not os.path.exists(backup_root):
                    os.makedirs(backup_root)
                backup_path = os.path.join(backup_root, sub_path)
                shutil.copytree(destination_path, backup_path)

            # move the files
            if os.path.exists(destination_path):
                shutil.rmtree(destination_path)
            shutil.copytree(source_path, destination_path)
        else:
            for file in os.listdir(source_path):
                if make_backup and os.path.exists(os.path.join(destination_path, file)):
                    if not os.path.exists(backup_root):
                        os.makedirs(backup_root)
                    shutil.copy2(os.path.join(destination_path, file),
                                 os.path.join(backup_root, file))
                shutil.copy2(os.path.join(source_path, file),
                             os.path.join(destination_path, file))
=======
    # tested
    "hyprland": {
        "template_dir": "./default_configs/hyprland/",
        'destination_dir': ".config/hypr/",
        "func": parse_hyprland,
    },
    
    # tested
    "waybar": {
        "template_dir": "./default_configs/waybar/",
        "destination_dir": ".config/waybar/",
        "func": parse_waybar,
    },

    "fastfetch": {
        "template_dir": "./default_configs/fastfetch/",
        "destination_dir": ".config/fastfetch/",
        "func": parse_fastfetch,
    }
}

order = [
    'colors',
    'i3',
    'hyprland', 
    'polybar',
    'waybar',
    'wallpaper',
    'nvim',
    'tmux',
    'rofi',
    'picom',
    'fish',
    'bash',
    'kitty',
    'alacritty',
    'fastfetch'
]
>>>>>>> 21ce9e2c7caa6d0dec3dc2f90d3e20aa24920b30


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


<<<<<<< HEAD
def main():
    args = parse_args()
    theme_name = args.theme
=======
def build_theme(theme_name, test):
    if test:
        theme_path = f"tests/{theme_name}"
    else:
        theme_path = f"themes/{theme_name}"

    with open(os.path.join(theme_path, "theme.json"), "r") as f:
        config = json.load(f)
    res, config = validate_config(config, theme_path)
    if not res:
        return

    dest_base = os.path.join(theme_path, "dots")
    if os.path.exists(dest_base):
        shutil.rmtree(dest_base)
        logger.info(f"removing directory {dest_base}")

    os.makedirs(dest_base)
    logger.info(f"created directory {dest_base}")
    
    tools_updated = {}
    for key in order:
        if key in config:
            logger.info(f"processing {key}")
            destination_dir = os.path.join(
                dest_base, path_config[key].get('destination_dir', ""))
            config = path_config[key]['func'](
                template_dir=path_config[key]['template_dir'],
                destination_dir=destination_dir,
                config=config,
                theme_path=theme_path
            )
            tools_updated[key] = {
                'destination_dir': destination_dir,
                    'filename': path_config[key].get('filename')
            }
    
    return tools_updated, theme_path, config

def overwrite_theme(tools_updated: Dict, theme_path: str, config: Dict):
    
    # looping over all tools
    backup_id = datetime.now().strftime("%Y-%m-%d::%X")
    backup_root = os.path.join(Path.home(), ".config", "dotfiles_backups")
    username = os.path.basename(os.path.expanduser("~"))

    for t in tools_updated:
        # skip colors and wallpaper 
        if t in ['colors', 'wallpaper']:
            continue

        # looping over each file in those configs
        in_repo_path = tools_updated[t]['destination_dir']
        config_path = in_repo_path.replace(os.path.join(theme_path, "dots"), "")
        if config_path[0] == '/':
            config_path = config_path[1:]
        
        print("config path = ", config_path)
        config_path = os.path.join(Path.home(), config_path)
        in_folder = os.path.basename(os.path.normpath(config_path)) not in [username, ".config"]
        
        if in_folder and 'filename' not in tools_updated[t]:
            raise ValueError("mis-configured tool")

        # create backup
        if os.path.exists(config_path):

            # if we're dealing with a subfolder inside config
            if in_folder:
                logger.info(f"{config_path} exists, creating backup")
                backup_path = os.path.join(backup_root, backup_id, t)
                shutil.copytree(config_path, backup_path)
                logger.info(f"backed up {config_path} to {backup_path}")

            # if we're dealing with an individual file that's not connected to a subfolder
            else:
                filename = tools_updated[t]['filename']
                backup_path = os.path.join(backup_root, backup_id, t)
                backup_file = os.path.join(backup_path, filename)
                src_path = os.path.join(config_path, filename)
                if not os.path.exists(backup_path):
                    os.makedirs(backup_path)
                shutil.copy2(src_path, backup_file)
                logger.info(f"backed up {src_path} to {backup_file}")
        
        if in_folder:
            for root, dirs, files in os.walk(in_repo_path):
                subfolder = root.replace(in_repo_path, "")
                dest_folder = os.path.join(config_path, subfolder)
                for file in files:
                    src_path = os.path.join(root, file)
                    dest_path = os.path.join(config_path, subfolder[1:], file)
                    shutil.copy2(src_path, dest_path)
                    logger.info(f"copied {src_path} to {dest_path}")
        else:
            src_path = os.path.join(in_repo_path, filename)
            dest_path = os.path.join(config_path, filename)
            shutil.copy2(src_path, dest_path)
            logger.info(f"copied {src_path} to {dest_path}")

    if 'theme_scripts' in config:
        path = config['theme_scripts']['path']
        for file in os.listdir(path):
            subprocess.call(os.path.join(path, file))




def main():
    args = parse_args()
    theme_name = args.theme
    
    tools_updated, theme_path, config = build_theme(theme_name, args.test)
    if args.migration_method == 'none': 
        return 
    if args.migration_method == 'overwrite':
        overwrite_theme(tools_updated, theme_path, config)
>>>>>>> 21ce9e2c7caa6d0dec3dc2f90d3e20aa24920b30

    tools_updated, theme_path = build_theme(theme_name, args.test)

    if args.migration_method == "none":
        return

    if args.migration_method == "copy":
        copy_theme(
            tools_updated,
            theme_path,
            args.make_backup,
            args.destination_root,
            args.destination_structure,
        )


if __name__ == "__main__":
    main()
