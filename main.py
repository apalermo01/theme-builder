import logging
import os
import argparse
import json
import shutil
from modules.utils import validate_config
from modules.colors import parse_colors
from modules.wallpaper import parse_wallpaper
from modules.i3 import parse_i3
from modules.nvim import parse_nvim


logger = logging.getLogger(__name__)
logging.basicConfig(level=logging.INFO)

path_config = {
    'colors': {
        'template_dir': None,
        'func': parse_colors
    },

    'wallpaper': {
        'template_dir': None,
        'func': parse_wallpaper
    },

    'i3wm': {
        'template_dir': 'default_configs/i3wm/',
        'dest_dir': ".config/i3/",
        'func': parse_i3
    },

    # 'polybar': {
    #     'template': './default_configs/polybar/',
    #     'dest': os.path.expanduser("~/.config/polybar/config.ini"),
    #     'func': parse_polybar
    # },
    #

    'nvim': {
        'template_dir': './default_configs/nvim/',
        'dest': ".config/nvim",
        'func': parse_nvim
    },
    #
    # 'tmux': {
    #     'template': './default_configs/tmux/',
    #     'dest': os.path.expanduser("~/"),
    #     'func': parse_tmux
    # },
    #
    # 'rofi': {
    #     'template': './default_configs/rofi/',
    #     # 'dest': os.path.expanduser("~/.config/rofi/"),
    #     'func': parse_rofi
    # },
    #
    # 'picom': {
    #     'template': './default_configs/picom/',
    #     # 'dest': os.path.expanduser("~/.config/"),
    #     'func': parse_picom,
    # },
    #
    # 'fish': {
    #     'template': './default_configs/fish/',
    #     # 'dest': os.path.expanduser('~/.config/fish/'),
    #     'func': parse_fish
    # },
    #
    # 'kitty': {
    #     'template': './default_configs/kitty/',
    #     # 'dest': os.path.expanduser('~/.config/kitty/'),
    #     'func': parse_kitty
    # },
    #
    # 'bash': {
    #     'template': './default_configs/bash/',
    #     # 'dest': os.path.expanduser('~/'),
    #     'func': parse_bash
    # },
    #
    # "alacritty": {
    #     "template": "./default_configs/alacritty/",
    #     # "dest": os.path.expanduser("~/.config/alacritty/alacritty.toml"),
    #     "func": parse_alacritty,
    # },
    #
    # "hyprland": {
    #     "template": "./default_configs/hyprland/",
    #     # "dest": os.path.expanduser('~/.config/hypr/'),
    #     "func": parse_hyprland,
    # },
    #
    # "waybar": {
    #     "template": "./default_configs/waybar/",
    #     # "dest": os.path.expanduser('~/.config/waybar/'),
    #     "func": parse_waybar,
    # }
}

order = [
    'colors',
    'i3wm',
    # 'hyprland',
    # 'polybar',
    # 'waybar',
    'wallpaper',
    'nvim',
    # 'tmux',
    # 'rofi',
    # 'picom',
    # 'fish',
    # 'bash',
    # 'kitty',
    # 'alacritty',
]


def parse_args():
    parser = argparse.ArgumentParser()
    parser.add_argument("--theme")
    args = parser.parse_args()
    return args


def main():
    args = parse_args()
    theme_name = args.theme
    path = f"./themes/{theme_name}/theme.json"

    with open(path, "r") as f:
        config = json.load(f)
    if not validate_config(config):
        return

    dest_base = os.path.join("themes", theme_name, "dots")
    if os.path.exists(dest_base):
        shutil.rmtree(dest_base)
        logger.info(f"removing directory {dest_base}")
    os.makedirs(dest_base)
    logger.info(f"created directory {dest_base}")

    for key in order:
        if key in config:
            logger.info(f"processing {key}")
            dest_dir = os.path.join(
                dest_base, path_config[key].get('dest_dir', ""))
            print("dest = ", dest_dir)
            config = path_config[key]['func'](
                template_dir=path_config[key]['template_dir'],
                dest_dir=dest_dir,
                config=config,
                theme_name=theme_name
            )


if __name__ == '__main__':
    main()
