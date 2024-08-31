import os
import shutil
from typing import Dict
import configparser
import logging
import json

logger = logging.getLogger(__name__)


def parse_polybar(config: Dict,
                  template: str,
                  dest: str,
                  theme_name: str):

    logger.info("Loading polybar...")
    polybar = configparser.ConfigParser()

    # load template or theme-specific config
    custom_path: str = f"./themes/{theme_name}/polybar/polybar.ini"
    if os.path.exists(custom_path):
        polybar.read(custom_path)
        logger.info(f"loaded custom polybar config from {custom_path}")
    else:
        polybar.read(template)
        logger.info("loaded default polybar config from default template")

    polybar = _parse_colors(polybar, theme_name)

    # write config
    with open(dest, "w") as f:
        polybar.write(f)

    logger.info(f"wrote polybar config to {dest}")

    # launch script
    src_script = "./scripts/i3wmthemer_bar_launch.sh"
    dest = "/" + os.path.join(*dest.split('/')[:-1])
    dest_script = os.path.join(dest, "i3wmthemer_bar_launch.sh")
    if not os.path.exists(dest):
        os.makedirs(dest)
    with open(dest_script, 'w') as f:
        pass
    shutil.copy2(src_script, dest)
    logger.info(f"copied polybar startup script from {src_script} to {dest}")

    return config


def _parse_colors(polybar: configparser.ConfigParser, theme_name: str):

    colorscheme_path: str =\
        os.path.join("themes", theme_name, "colors", "colorscheme.json")

    with open(colorscheme_path, "r") as f:
        colorscheme: Dict = json.load(f)

    for c in polybar['colors']:
        color_str = polybar['colors'][c]
        color_key = color_str.split('<')[1].split('>')[0]
        if color_key in colorscheme:
            polybar['colors'][c] = colorscheme[color_key]

    return polybar
