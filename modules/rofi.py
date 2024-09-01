
import logging
from typing import Dict
import os
from .utils import default_parser

logger = logging.getLogger(__name__)


def parse_rofi(config: Dict,
               template: str,
               dest: str,
               theme_name: str) -> Dict:

    logger.info("Loading rofi...")
    dest = os.path.join(dest, "config.rasi")
    theme_config = os.path.join("themes", theme_name, "rofi", "config.rasi")

    # copy template file to destination
    if "default_path" in config['rofi']:
        template = config['rofi']['default_path']
    else:
        template = os.path.join(template, "config.rasi")

    default_parser(template, dest, theme_config, theme_name)
    return config
