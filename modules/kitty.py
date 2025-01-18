import logging
from typing import Dict
import os
from .utils import module_wrapper, append_text

logger = logging.getLogger(__name__)


@module_wrapper(tool='kitty')
def parse_kitty(config: Dict,
                template_dir: str,
                destination_dir: str,
                theme_path: str) -> Dict:

    logger.info("Loading kitty...")

    if "fish" in config:
        append_text(os.path.join(
            destination_dir,
            'kitty.conf'
        ), "chsh -s /usr/bin/fish\n")

    if "font_family" in config:
        append_text(os.path.join(
            destination_dir,
            'kitty.conf'
        ), f"font_family {config['font_family']}\n")

    return config
