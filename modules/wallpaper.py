import os
from typing import Dict, List
import logging
import shutil

logger = logging.getLogger(__name__)


def parse_wallpaper(
        config: Dict,
        theme_name: str,
        **kwargs
) -> Dict:
    """Parse wallpaper info

    config options:
    method: "feh" (TODO: or hyprpaper)
    file: filenanme in <project root>/wallpapers
    """

    logger.info("Loading wallpaper...")

    allowed_methods: List[str] = ['feh']
    method: str = config['wallpaper'].get('method', 'feh')

    if method not in allowed_methods:
        raise ValueError("Invalid method. Expected one of " +
                         allowed_methods + f" but got {method}")

    if method == 'feh':
        return feh_theme(config, theme_name)


def feh_theme(config: Dict, theme_name: str):

    wallpaper_path: str = config['wallpaper']['file']

    # if just the filename was given, look in the project's wallpaper folder:
    if '/' not in wallpaper_path:
        wallpaper_path = os.path.join('.', 'wallpapers', wallpaper_path)

    wallpaper_dest: str = os.path.expanduser(
        f"~/Pictures/wallpapers/{wallpaper_path.split('/')[-1]}"
    )

    if not os.path.exists(os.path.expanduser("~/Pictures/wallpapers/")):
        os.makedirs(os.path.expanduser("~/Picutres/wallpapers/"))

    if 'i3wm' not in config:
        raise KeyError(
            "This parser is only configured to work with i3 if feh is used. " +
            "Please add it to the theme's config")

    text: str = f"exec_always feh --bg-fill {wallpaper_dest}"

    # TODO: copy text to additional i3 config file
    tmp_path: str = "./tmp/i3.config"

    with open(tmp_path, 'a') as f:
        f.write(text)

    logger.info(f"added {text} to i3 config")

    shutil.copy2(src=wallpaper_path, dst=wallpaper_dest)

    logger.info(f"copied {wallpaper_path} to {wallpaper_dest}")

    return config
