import logging
from typing import Dict
import os
from .utils import default_parser, configure_destination

logger = logging.getLogger(__name__)


def parse_alacritty(config: Dict,
                    template: str,
                    dest: str,
                    theme_name: str) -> Dict:

    logger.info("Loading alacritty...")
    dest = configure_destination(dest, "alacritty", "alcritty.toml")
    theme_config = os.path.join(
        "themes", theme_name, "alacritty", "alacritty.toml")

    # copy template file to destination
    if "default_path" in config['rofi']:
        template = config['rofi']['default_path']
    else:
        template = os.path.join(template, "alacritty.toml")

    default_parser(template,
                   # dest,
                   theme_config,
                   theme_name)
    return config
