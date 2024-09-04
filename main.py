import logging
import os
import argparse
import json
from modules.utils import validate_config
from modules.colors import parse_colors
from modules.wallpaper import parse_wallpaper
from modules.i3 import parse_i3
from modules.polybar import parse_polybar
from modules.nvim import parse_nvim
from modules.nvchad import parse_nvchad
from modules.tmux import parse_tmux
from modules.rofi import parse_rofi
from modules.picom import parse_picom
from modules.fish import parse_fish
from modules.kitty import parse_kitty



logger = logging.getLogger(__name__)
logging.basicConfig(level=logging.INFO)

path_config = {
    'colors': {
        'template': None,
        'dest': None,
        'func': parse_colors
    },

    'wallpaper': {
        'template': None,
        'dest': None,
        'func': parse_wallpaper
    },

    'i3wm': {
        'template': './default_configs/i3/',
        'dest': os.path.expanduser("~/.config/i3/"),
        'func': parse_i3
    },

    'polybar': {
        'template': './default_configs/polybar/',
        'dest': os.path.expanduser("~/.config/polybar/config.ini"),
        'func': parse_polybar
    },

    'nvim': {
        'template': './default_configs/nvim/',
        'dest': os.path.expanduser("~/.config/nvim/"),
        'func': parse_nvim
    },

    'nvchad': {
        'template': './default_configs/nvchad/',
        'dest': os.path.expanduser("~/.config/nvim/"),
        'func': parse_nvchad
    },

    'tmux': {
        'template': './default_configs/tmux/',
        'dest': os.path.expanduser("~/"),
        'func': parse_tmux
    },

    'rofi': {
        'template': './default_configs/rofi/',
        'dest': os.path.expanduser("~/.config/rofi/"),
        'func': parse_rofi
    },

    'picom': {
        'template': './default_configs/picom/',
        'dest': os.path.expanduser("~/.config/"),
        'func': parse_picom,
    },

    'fish': {
        'template': './default_configs/fish/',
        'dest': os.path.expanduser('~/.config/fish/'),
        'func': parse_fish
    },

    'kitty': {
        'template': './default_configs/kitty/',
        'dest': os.path.expanduser('~/.config/kitty/'),
        'func': parse_kitty
    }
}

order = [
    'colors',
    'i3wm',
    'polybar',
    'wallpaper',
    'nvim',
    'nvchad',
    'tmux',
    'rofi',
    'picom',
    'fish',
    'kitty'
]


def parse_args():
    parser = argparse.ArgumentParser()
    parser.add_argument("--theme")
#    parser.add_argument("--backup", action=argparse.BooleanOptionalAction)
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
    for key in order:
        if key in config:
            logger.info(f"processing {key}")
            config = path_config[key]['func'](
                template=path_config[key]['template'],
                dest=path_config[key]['dest'],
                config=config,
                theme_name=theme_name
            )


if __name__ == '__main__':
    main()
