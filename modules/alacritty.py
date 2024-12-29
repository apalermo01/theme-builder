import logging
from typing import Dict
import os
from .utils import default_parser, configure_destination
# TODO: need to update this
logger = logging.getLogger(__name__)


def parse_alacritty(config: Dict,
                    template: str,
                    dest: str,
                    theme_path: str) -> Dict:

    logger.info("Loading alacritty...")
    dest = configure_destination(dest, "alacritty", "alcritty.toml")
    theme_config = os.path.join(
        theme_path, alacritty", "alacritty.toml")

    # copy template file to destination
    if "default_path" in config['alacritty']:
        template = config['alacritty']['default_path']
    else:
        template = os.path.join(template, "alacritty.toml")

    default_parser(template,
                   # dest,
                   theme_config,
                   theme_name)
    return config
