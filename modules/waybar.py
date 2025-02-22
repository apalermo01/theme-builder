import json
import logging
import os
import shutil
from typing import Dict

from .utils import module_wrapper

logger = logging.getLogger(__name__)


@module_wrapper(tool="waybar")
def parse_waybar(
    config: Dict, template_dir: str, destination_dir: str, theme_path: str
):
    """
    Requires waybar config to be fully defined in the theme
    """

    css_path = config["waybar"].get("css_path", "style.css")
    css_path = os.path.join(theme_path, "build", "waybar", css_path)
    with open(css_path, "r") as f:
        css: list = f.readlines()

    css = _parse_colors(css, theme_path)

    with open(css_path, "w") as f:
        for line in css:
            f.write(line)

    return config


def _parse_colors(css, theme_path: str):

    colorscheme_path: str = os.path.join(theme_path, "colors", "colorscheme.json")

    with open(colorscheme_path, "r") as f:
        colorscheme: Dict = json.load(f)

    new_lines = []
    for line in css:
        for color in colorscheme:
            line = line.replace(f"<{color}>", colorscheme[color])
        new_lines.append(line)

    return new_lines
