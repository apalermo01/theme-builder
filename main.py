import logging
from scripts.colors import parse_colors
from scripts.i3 import parse_i3
from scripts.wallpapers import parse_wallpaper
from scripts.bash import parse_bash
from scripts.polybar import parse_polybar
from scripts.vim import parse_vim
from scripts.nvim import parse_nvim
from scripts.picom import parse_picom
from scripts.tmux import parse_tmux
from scripts.hypr import parse_hypr
from scripts.alacritty import parse_alacritty
from scripts.fish import parse_fish
from scripts.waybar import parse_waybar
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
        'template': './default_configs/i3.config',
        'dest': os.path.expanduser("~/.config/i3/config"),
        'func': parse_i3,
        },
    'hypr': {
        'template': './default_configs/hyper.config',
        'dest': os.path.expanduser('~/.config/hypr/hyprland.conf'),
        'func': parse_hypr,
        },
    'polybar': {
        'template': './default_configs/polybar.ini',
        'dest': os.path.expanduser("~/.config/polybar/config.ini"),
        'func': parse_polybar
        },
    'waybar': {
        'template': {
            'config': './default_configs/waybar/config',
            'css': './default_configs/waybar/style.css'},
        'dest': {
            'config': os.path.expanduser("~/.config/waybar/config"),
            'css': os.path.expanduser("~/.config/waybar/style.css")
            },
        'func': parse_waybar,
        },
    'vim': {
        'template': './default_configs/init.vim',
        'dest': os.path.expanduser("~/.config/nvim/init.vim"),
        'func': parse_vim,
        },
    'nvim': {
        'template': './default_configs/init.lua',
        'dest': os.path.expanduser("~/.config/nvim/init.lua"),
        'func': parse_nvim,
        },
    'bash': {
        'template': './default_configs/.bashrc',
        'dest': os.path.expanduser("~/.bashrc"),
        'func': parse_bash
        },
    'fish': {
        'template': './default_configs/config.fish',
        'dest': os.path.expanduser("~/.config/fish/config.fish"),
        'func': parse_fish
        },
    'picom': {
        'template': './default_configs/picom.conf',
        'dest': os.path.expanduser("~/.config/picom.conf"),
        'func': parse_picom,
        },
    'tmux': {
        'template': './default_configs/.tmux.conf',
        'dest': os.path.expanduser("~/.tmux.conf"),
        'func': parse_tmux,
    },
    "alacritty": {
        "template": "./default_configs/alacritty.toml",
        "dest": os.path.expanduser("~/.config/alacritty/alacritty.toml"),
        "func": parse_alacritty,
        },
    }

order = ['colors',
         'wallpaper',
         'i3wm',
         'hypr',
         'polybar',
         'waybar',
         'vim',
         'bash',
         'alacritty',
         'picom',
         'tmux'
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

