import os
from typing import Dict
import logging
from textwrap import dedent
import shutil


logger = logging.getLogger(__name__)


def parse_wallpaper(config: Dict, *args, **kwargs):
    """Parse wallpaper info

    Parameters
    ----------
    config : Dict

    """
    if isinstance(config['wallpaper'], str):
        name = config['wallpaper']
        config['wallpaper'] = {
                'method': 'feh',
                'name': name}

    method = config['wallpaper']['method']

    if method == 'feh':
        config = feh_theme(config)

    elif method == 'hyprpaper':
        config = hyprpaper_theme(config)

    else:
        raise NotImplementedError

    return config

def hyprpaper_theme(config: Dict):

    wallpaper_path = config['wallpaper']['name']
    hyprpaper_config_path = os.path.expanduser("~/.config/hypr/hyprpaper.conf")

    # if just the filename was given, look in the project's wallpaper folder:
    if '/' not in wallpaper_path:
        wallpaper_path = os.path.join('.', 'wallpapers', wallpaper_path)

    logger.info(f"wallpaper path is: {wallpaper_path}")

    if not os.path.exists(os.path.expanduser("~/Pictures/wallpapers/")):
        os.makedirs(os.path.expanduser("~/Pictures/wallpapers/"))

    wp_dest_path = os.path.expanduser(f"~/Pictures/wallpapers/{wallpaper_path.split('/')[-1]}")
    logger.warning("Loading wallpaper")

    if 'hyprpaper_path' not in config['wallpaper']:
        with open(hyprpaper_config_path, "w") as f:
            f.write(f"preload={wp_dest_path}\n")
            f.write(f"wallpaper= eDP-1, {wp_dest_path}\n")
            f.write(f"wallpaper= HDMI-A-2, {wp_dest_path}\n")
            f.write(f"wallpaper= DP-1, {wp_dest_path}\n")
    else:
        with open(config['wallpaper']['hyprpaper_path'], "r") as f_out, \
            open(hyprpaper_config_path, "w") as f_in:
            for line in f_out.readlines():
                f_in.write(line)

    shutil.copy2(src=wallpaper_path,
                 dst=wp_dest_path)

    return config
def feh_theme(config: Dict):

    # wallpaper path is a path or filename
    wallpaper_path = config['wallpaper']['name']

    # if just the filename was given, look in the project's wallpaper folder:
    if '/' not in wallpaper_path:
        wallpaper_path = os.path.join('.', 'wallpapers', wallpaper_path)

    logger.info(f"wallpaper path is: {wallpaper_path}")

    if not os.path.exists(os.path.expanduser("~/Pictures/wallpapers/")):
        os.makedirs(os.path.expanduser("~/Picutres/wallpapers/"))

    logger.warning("Loading wallpaper")

    if 'i3wm' in config:
        if 'extra_lines' not in config['i3wm']:
            config['i3wm']['extra_lines'] = []

        config['i3wm']['extra_lines'].append(dedent(f"""
            \nexec_always feh --bg-fill $HOME/Pictures/wallpapers/{wallpaper_path.split("/")[-1]}
            """))
    shutil.copy2(src=wallpaper_path,
                 dst=os.path.expanduser(f"~/Pictures/wallpapers/{wallpaper_path.split('/')[-1]}"))


    return config

