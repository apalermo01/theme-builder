import argparse
import logging
import os
import yaml
import shutil

from modules import modules
from modules.utils import validate_config, configure_colors

logger = logging.getLogger(__name__)
logging.basicConfig(level=logging.INFO)

def get_theme_config(theme_path: str) -> dict:
    all_files = os.listdir(theme_path)
    for f in all_files:
        if "theme" in f:
            extension = f.split('.')[1]

            if extension == 'json':
                ftype: str = 'json'

            elif extension in ['yml', 'yaml']:
                ftype: str = 'yaml'

            else:
                raise ValueError(f"Invalid extension for {f}, must be json, yaml, or yml")

            with open(os.path.join(theme_path, f), "r") as f:
                if ftype == 'json':
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

    logger.info("=======================================")
    logger.info("=========== BUILDING CONFIG ===========")
    logger.info("=======================================")

    tools_updated = {}
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
    ]
    for key in order:
        if key in config:
            logger.info(f"processing {key}")
            
            destination_path = os.path.join(
                destination_base,
                path_config[key]['destination_path']
            )

            if 'template_path' in config[key]:
                template_path = config[key]['template_path']
            else:
                template_path = path_config[key]['template_path']

            config = modules[key](
                template_dir = template_path,
                destination_dir = destination_path,
                config = config,
                theme_path = theme_path
            )
    
    configure_colors(theme_path)
    return tools_updated, theme_path

def parse_args():
    parser = argparse.ArgumentParser()
    parser.add_argument("--theme")
    parser.add_argument("--test",
                        default=True,
                        action=argparse.BooleanOptionalAction)

    parser.add_argument("--migration-method",
                        default="none",
                        choices=["none", "overwrite"])

    parser.add_argument("--destination-root",
                        default="")

    parser.add_argument("--make-backup",
                        default=True,
                        action=argparse.BooleanOptionalAction)

    args = parser.parse_args()
    return args


def main():
    args = parse_args()
    theme_name = args.theme
    
    tools_updated, theme_path = build_theme(theme_name, args.test)
    # if args.migration_method == 'none': 
    #     return 
    # if args.migration_method == 'overwrite':
    #     copy_theme(tools_updated, theme_path, args.make_backup)

if __name__ == '__main__': 
    main()
