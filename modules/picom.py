import logging
from typing import Dict
import os
from .utils import default_parser

logger = logging.getLogger(__name__)


def parse_picom(config: Dict,
                template: str,
                dest: str,
                theme_name: str) -> Dict:

    logger.info("Loading picom...")
    dest = os.path.join(dest, "picom.conf")
    theme_config = os.path.join("themes", theme_name, "picom", "picom.conf")

    # copy template file to destination
    if "default_path" in config['picom']:
        template = config['picom']['default_path']
    else:
        template = os.path.join(template, "picom.conf")

    default_parser(template, dest, theme_config, theme_name)
    return config
