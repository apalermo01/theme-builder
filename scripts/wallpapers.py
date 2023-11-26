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
    else:
        raise NotImplementedError
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
        # TODO: move this functionality to the i3 module
        if 'extra_lines' not in config['i3wm']:
            config['i3wm']['extra_lines'] = []

        config['i3wm']['extra_lines'].append(dedent(f"""
            \nexec_always feh --bg-fill $HOME/Pictures/wallpapers/{wallpaper_path.split("/")[-1]}
            """))
    shutil.copy2(src=wallpaper_path,
                 dst=os.path.expanduser(f"~/Pictures/wallpapers/{wallpaper_path.split('/')[-1]}"))


    return config

