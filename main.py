import logging
from scripts.colors import parse_colors
from scripts.i3 import parse_i3
from scripts.wallpapers import parse_wallpaper
from scripts.bash import parse_bash
from scripts.polybar import parse_polybar
from scripts.vim import parse_vim
from scripts.picom import parse_picom
import os
import argparse
import json
import sys

logger = logging.getLogger(__name__)
logging.basicConfig(level=logging.INFO)

path_config = {
    'colors': {
        'template': None,
        'dest': None,
        'func': parse_colors,
        },
    'wallpaper': {
        'template': None,
        'dest': None,
        'func': parse_wallpaper,
        },
    'i3wm': {
        'template': './i3.config',
        'dest': os.path.expanduser("~/.config/i3/config"),
        'func': parse_i3,
        },
    'polybar': {
        'template': './polybar.ini',
        'dest': os.path.expanduser("~/.config/polybar/config.ini"),
        'func': parse_polybar
        },
    'vim': {
        'template': './init.vim',
        'dest': os.path.expanduser("~/.config/nvim/init.vim"),
        'func': parse_vim,
        },
    'bash': {
        'template': './.bashrc',
        'dest': os.path.expanduser("~/.bashrc"),
        'func': parse_bash
        },
    'picom': {
        'template': None,
        'dest': os.path.expanduser("~/.config/picom.conf"),
        'func': parse_picom,
        }
    }

order = ['colors',
         'wallpaper',
         'i3wm',
         'polybar',
         'vim',
         'bash',
         'picom'
         ]

def parse_args():
    parser = argparse.ArgumentParser()
    parser.add_argument("--theme")
    parser.add_argument("--backup", action=argparse.BooleanOptionalAction)
    args = parser.parse_args()
    return args

def main():
    args = parse_args()
    theme_name = args.theme
    path = f"./themes/{theme_name}/{theme_name}.json"

    with open(path, "r") as f:
        config = json.load(f)

    for key in order:
        if key in config:
            config = path_config[key]['func'](
                    template = path_config[key]['template'],
                    dest = path_config[key]['dest'],
                    config = config,
                    theme_name = theme_name
                    )

if __name__ == '__main__':
    main()

