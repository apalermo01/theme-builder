import logging
from typing import Dict
import os
from .utils import module_wrapper, append_text

logger = logging.getLogger(__name__)


@module_wrapper(tool='kitty')
def parse_kitty(config: Dict,
                template_dir: str,
                destination_dir: str,
                theme_name: str) -> Dict:

    logger.info("Loading kitty...")
    # dest = os.path.join(dest, "kitty.conf")

    if "fish" in config:
        append_text(os.path.join(
            destination_dir,
            'kitty.conf'
        ), "chsh -s /usr/bin/fish\n")

    if "font" in config:
        append_text(os.path.join(
            destination_dir,
            'kitty.conf'
        ), f"font_family {config['font']}\n")

    return config
