import logging
import os
import argparse
import json
import sys
import modules as m

logger = logging.getLogger(__name__)
logging.basicConfig(level=logging.INFO)

path_config = {
    'colors': {
        'template': None,
        'dest': None,
        'func': m.colors.parse_colors
    },

    'wallpaper': {
        'template': None,
        'dest': None,
        'func': m.wallpaper.parse_wallpaper
    },

    'i3wm': {
        'template': './default_configs/i3/',
        'dest': os.paht.expanduser("~/.config/i3/"),
        'func': m.i3.parse_i3
    }
}

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



