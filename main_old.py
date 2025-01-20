import argparse
import json
import logging
import os
import shutil
from datetime import datetime
from pathlib import Path
from typing import Dict

import yaml

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

logger = logging.getLogger(__name__)
logging.basicConfig(level=logging.INFO)

# path_config = {
#     'colors': {
#         'template_dir': None,
#         'func': parse_colors
#     },
#
#     'wallpaper': {
#         'template_dir': None,
#         'func': parse_wallpaper
#     },
#
#     'i3': {
#         'template_dir': 'default_configs/i3/',
#         'destination_dir': ".config/i3",
#         'func': parse_i3
#     },
#
#     'polybar': {
#         'template_dir': 'default_configs/polybar/',
#         'destination_dir': ".config/polybar",
#         'func': parse_polybar
#     },
#
#     'nvim': {
#         'template_dir': './default_configs/nvim/',
#         'destination_dir': ".config/nvim",
#         'func': parse_nvim
#     },
#
#     'tmux': {
#         'template_dir': './default_configs/tmux/',
#         'destination_dir': "",
#         'func': parse_tmux,
#         "filename": ".tmux.conf"
#     },
#
#     'rofi': {
#         'template_dir': './default_configs/rofi/',
#         'destination_dir': ".config/rofi",
#         'func': parse_rofi
#     },
#
#     'picom': {
#         'template_dir': './default_configs/picom/',
#         'destination_dir': ".config/",
#         'func': parse_picom,
#         "filename": "picom.conf"
#     },
#
#     'fish': {
#         'template_dir': './default_configs/fish/',
#         'destination_dir': '.config/fish/',
#         'func': parse_fish
#     },
#
#     'kitty': {
#         'template_dir': './default_configs/kitty/',
#         'destination_dir': '.config/kitty/',
#         'func': parse_kitty
#     },
#
#     'bash': {
#         'template_dir': './default_configs/bash/',
#         'destination_dir': '',
#         'func': parse_bash,
#         "filename": ".bashrc"
#     },
#
#     "alacritty": {
#         "template_dir": "./default_configs/alacritty/",
#         "testination_dir": ".config/alacritty/",
#         "func": parse_alacritty,
#     },
#
#     "hyprland": {
#         "template_dir": "./default_configs/hyprland/",
#         'destination_dir': ".config/hypr/",
#         "func": parse_hyprland,
#     },
#
#     "waybar": {
#         "template_dir": "./default_configs/waybar/",
#         "destination_dir": ".config/waybar/",
#         "func": parse_waybar,
#     }
# }
#
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


def parse_args():
    parser = argparse.ArgumentParser()
    parser.add_argument("--theme")
    parser.add_argument("--test", default=True, action=argparse.BooleanOptionalAction)
    parser.add_argument(
        "--migration-method", default="none", choices=["none", "overwrite", "copy"]
    )
    parser.add_argument("--copy-path", default="")
    parser.add_argument(
        "--make-backup", default=True, action=argparse.BooleanOptionalAction
    )

    args = parser.parse_args()
    return args


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
                dest_base, path_config[key].get("destination_dir", "")
            )
            config = path_config[key]["func"](
                template_dir=path_config[key]["template_dir"],
                destination_dir=destination_dir,
                config=config,
                theme_path=theme_path,
            )
            tools_updated[key] = {
                "destination_dir": destination_dir,
                "filename": path_config[key].get("filename"),
            }

    return tools_updated, theme_path


# def copy_theme(tools_updated: Dict, theme_path: str, copy_path: str):


def copy_theme(tools_updated: Dict, theme_path: str, make_backup: bool):

    # looping over all tools
    if make_backup:
        backup_id = datetime.now().strftime("%Y-%m-%d::%X")
        backup_root = os.path.join(Path.home(), ".config", "dotfiles_backups")

    username = os.path.basename(os.path.expanduser("~"))

    for t in tools_updated:
        # skip colors and wallpaper
        if t in ["colors", "wallpaper"]:
            continue

        # looping over each file in those configs
        in_repo_path = tools_updated[t]["destination_dir"]
        config_path = in_repo_path.replace(os.path.join(theme_path, "dots"), "")
        if config_path[0] == "/":
            config_path = config_path[1:]

        config_path = os.path.join(Path.home(), config_path)
        in_folder = os.path.basename(os.path.normpath(config_path)) not in [
            username,
            ".config",
        ]

        if in_folder and "filename" not in tools_updated[t]:
            raise ValueError("mis-configured tool")

        # create backup
        if os.path.exists(config_path):

            # if we're dealing with a subfolder inside config
            if in_folder and make_backup:
                logger.info(f"{config_path} exists, creating backup")
                backup_path = os.path.join(backup_root, backup_id, t)
                shutil.copytree(config_path, backup_path)
                logger.info(f"backed up {config_path} to {backup_path}")

            # if we're dealing with an individual file that's not connected to a subfolder
            elif make_backup:
                filename = tools_updated[t]["filename"]
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


def main():
    args = parse_args()
    theme_name = args.theme

    tools_updated, theme_path = build_theme(theme_name, args.test)
    if args.migration_method == "none":
        return
    if args.migration_method == "overwrite":
        copy_theme(tools_updated, theme_path, args.make_backup)


if __name__ == "__main__":
    main()
