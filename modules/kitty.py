import logging
import os
from typing import Dict

from .utils import append_text, module_wrapper

logger = logging.getLogger(__name__)


@module_wrapper(tool="kitty")
def parse_kitty(
    config: Dict, template_dir: str, destination_dir: str, theme_path: str
) -> Dict:

    logger.info("Loading kitty...")

    if "fish" in config:
        append_text(
            os.path.join(destination_dir, "kitty.conf"), "chsh -s /usr/bin/fish\n"
        )

    if "font_family" in config:
        append_text(
            os.path.join(destination_dir, "kitty.conf"),
            f"font_family   family=\"{config['font_family']}\"\n",
        )
        append_text(
            os.path.join(destination_dir, "kitty.conf"),
            f"bold_font     auto\n",
        )
        append_text(
            os.path.join(destination_dir, "kitty.conf"),
            f"italic_font     auto\n",
        )
        append_text(
            os.path.join(destination_dir, "kitty.conf"),
            f"bold_italic_font     auto\n",
        )

    return config
