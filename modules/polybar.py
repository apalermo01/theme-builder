import os
import shutil
from typing import Dict
import configparser
import logging
import json
from .utils import module_wrapper

logger = logging.getLogger(__name__)


@module_wrapper(tool='polybar')
def parse_polybar(config: Dict,
                  template_dir: str,
                  destination_dir: str,
                  theme_name: str):

    logger.info("Loading polybar...")
    polybar = configparser.ConfigParser()

    # path = os.path.join("themes", "polybar.ini")
    # # load template or theme-specific config
    # polybar.read(path)
    # logger.info(f"loaded custom polybar config from {path}")

    polybar_files = os.walk(destination_dir)

    for root, dirs, files in polybar_files:
        for file in files:
            config_subfile = os.path.join(root, file)
            print("reading config subfile: ", config_subfile)
            polybar = configparser.ConfigParser()
            polybar.read(config_subfile)
            if 'colors' in polybar:
                polybar = _parse_colors(polybar, theme_name)
                with open(config_subfile, "w") as f:
                    polybar.write(f)
                logger.info(f"wrote polybar config with colors to {
                            config_subfile}")

    # # launch script
    src_script = "./scripts/i3wmthemer_bar_launch.sh"
    destination_dir = os.path.join(*destination_dir.split('/')[:-1])
    destination_dir_script = os.path.join(
        destination_dir, "i3wmthemer_bar_launch.sh")
    with open(destination_dir_script, 'w') as f:
        pass
    shutil.copy2(src_script, destination_dir)
    logger.info(f"copied polybar startup script from {
                src_script} to {destination_dir}")

    return config


def _parse_colors(polybar: configparser.ConfigParser, theme_name: str):

    colorscheme_path: str =\
        os.path.join("themes", theme_name, "colors", "colorscheme.json")

    with open(colorscheme_path, "r") as f:
        colorscheme: Dict = json.load(f)

    for c in polybar['colors']:
        color_str = polybar['colors'][c]
        if '<' not in color_str:
            continue
        color_key = color_str.split('<')[1].split('>')[0]
        if color_key in colorscheme:
            polybar['colors'][c] = colorscheme[color_key]

    return polybar
