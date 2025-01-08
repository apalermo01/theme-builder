import argparse
import json
import logging
import os
import shutil

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

path_config = {
    # tested
    'colors': {
        'template_dir': None,
        'func': parse_colors
    },
    
    # tested
    'wallpaper': {
        'template_dir': None,
        'func': parse_wallpaper
    },
    
    #tested
    'i3wm': {
        'template_dir': 'default_configs/i3wm/',
        'destination_dir': ".config/i3/",
        'func': parse_i3
    },
    
    # tested
    'polybar': {
        'template_dir': 'default_configs/polybar/',
        'destination_dir': ".config/polybar/",
        'func': parse_polybar
    },
    
    # tested
    'nvim': {
        'template_dir': './default_configs/nvim/',
        'destination_dir': ".config/nvim",
        'func': parse_nvim
    },
    
    # tested
    'tmux': {
        'template_dir': './default_configs/tmux/',
        'destination_dir': "",
        'func': parse_tmux
    },

    # minimal, no test needed
    'rofi': {
        'template_dir': './default_configs/rofi/',
        'destination_dir': ".config/rofi",
        'func': parse_rofi
    },
    
    # minimal, no test needed
    'picom': {
        'template_dir': './default_configs/picom/',
        'destination_dir': ".config/",
        'func': parse_picom,
    },

    # tested
    'fish': {
        'template_dir': './default_configs/fish/',
        'destination_dir': '.config/fish/',
        'func': parse_fish
    },

    # tested
    'kitty': {
        'template_dir': './default_configs/kitty/',
        'destination_dir': '.config/kitty/',
        'func': parse_kitty
    },

    # tested
    'bash': {
        'template_dir': './default_configs/bash/',
        'destination_dir': '',
        'func': parse_bash
    },
    
    # minimal, no test needed
    "alacritty": {
        "template_dir": "./default_configs/alacritty/",
        "testination_dir": ".config/alacritty/",
        "func": parse_alacritty,
    },

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
    }
}

order = [
    'colors',
    'i3wm',
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
]


def parse_args():
    parser = argparse.ArgumentParser()
    parser.add_argument("--theme")
    parser.add_argument("--test", default=True, action=argparse.BooleanOptionalAction)
    args = parser.parse_args()
    return args


def build_theme(theme_name, test):
    if test:
        theme_path = f"./tests/{theme_name}"
    else:
        theme_path = f"./themes/{theme_name}"

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

    for key in order:
        if key in config:
            logger.info(f"processing {key}")
            destination_dir = os.path.join(
                dest_base, path_config[key].get('destination_dir', ""))
            print("dest = ", destination_dir)
            config = path_config[key]['func'](
                template_dir=path_config[key]['template_dir'],
                destination_dir=destination_dir,
                config=config,
                theme_path=theme_path
            )

def main():
    args = parse_args()
    theme_name = args.theme
    
    build_theme(theme_name, args.test)

if __name__ == '__main__':
    main()
