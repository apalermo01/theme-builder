import logging
from typing import Dict
import os
from .utils import default_parser

logger = logging.getLogger(__name__)


def parse_tmux(config: Dict,
               template: str,
               dest: str,
               theme_name: str) -> Dict:

    logger.info("Loading tmux...")
    dest = os.path.join(dest, ".tmux.conf")
    theme_config = os.path.join("themes", theme_name, "tmux", "tmux.conf")

    # copy template file to destination
    if "default_path" in config['tmux']:
        template = config['tmux']['default_path']
    else:
        template = os.path.join(template, "tmux.conf")

    default_parser(template, dest, theme_config, theme_name)
    return config
