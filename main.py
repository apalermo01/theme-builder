import argparse
import json
import logging
import os
import shutil
from typing import Dict
from pathlib import Path 
from datetime import datetime

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
    'i3': {
        'template_dir': 'default_configs/i3/',
        'destination_dir': ".config/i3",
        'func': parse_i3
    },
    
    # tested
    'polybar': {
        'template_dir': 'default_configs/polybar/',
        'destination_dir': ".config/polybar",
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
        'func': parse_tmux,
        "filename": ".tmux.conf"
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
        "filename": "picom.conf"
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
        'func': parse_bash,
        "filename": ".bashrc"
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


def parse_args():
    parser = argparse.ArgumentParser()
    parser.add_argument("--theme")
    parser.add_argument("--test", default=True, action=argparse.BooleanOptionalAction)
    parser.add_argument("--migration-method", default="none", choices=["none", "overwrite"])
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
    
    return tools_updated, theme_path

def overwrite_theme(tools_updated: Dict, theme_path: str):
    
    # looping over all tools
    backup_id = datetime.now().strftime("%Y-%m-%d::%X")
    backup_root = os.path.join(Path.home(), ".config", "dotfiles_backups")
    username = os.path.basename(os.path.expanduser("~"))

    for t in tools_updated:
        print("="*80)
        print("tool = ", t)
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
                print("backup path = ", backup_path)
                print("filename = ", filename)
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
    if args.migration_method == 'none': 
        return 
    if args.migration_method == 'overwrite':
        overwrite_theme(tools_updated, theme_path)

if __name__ == '__main__':
    main()
