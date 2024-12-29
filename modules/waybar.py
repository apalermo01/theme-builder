import os
import shutil
from typing import Dict
import logging
import json


logger = logging.getLogger(__name__)

CSS_TMP_PATH = os.path.join("./tmp/waybar_css.css")
CONFIG_TMP_PATH = os.path.join("./tmp/waybar_config")


def parse_waybar(config: Dict,
                 template: str,
                 destination_dir: str,
                 theme_name: str):
    """
    Requires waybar config to be fully defined in the theme
    """

    custom_path: str = f"./themes/{theme_name}/waybar/"
    config_path: str = os.path.join(custom_path, "config")
    css_path: str = os.path.join(custom_path, "style.css")

    if not os.path.exists(config_path):
        raise FileNotFoundError(f"could not find {config_path}")
    if not os.path.exists(css_path):
        raise FileNotFoundError(f"could not find {css_path}")

    with open(css_path, "r") as f:
        css: list = f.readlines()

    css = _parse_colors(css, theme_name)

    shutil.copy2(config_path, CONFIG_TMP_PATH)
    with open(CSS_TMP_PATH, "w") as f:
        for line in css:
            f.write(line)

    config_final_path = os.path.expanduser("~/.config/waybar/config")
    css_final_path = os.path.expanduser("~/.config/waybar/style.css")

    shutil.copy2(CONFIG_TMP_PATH, config_final_path)
    logger.info(f"wrote {CONFIG_TMP_PATH} to {config_final_path}")
    shutil.copy2(CSS_TMP_PATH, css_final_path)
    logger.info(f"wrote {CSS_TMP_PATH} to {css_final_path}")

    return config


def _parse_colors(css, theme_name: str):

    colorscheme_path: str = \
        os.path.join("themes", theme_name, "colors", "colorscheme.json")

    with open(colorscheme_path, "r") as f:
        colorscheme: Dict = json.load(f)

    new_lines = []
    for line in css:
        for color in colorscheme:
            line = line.replace(f"<{color}>", colorscheme[color])
        new_lines.append(line)
    return new_lines
