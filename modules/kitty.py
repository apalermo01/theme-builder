import logging
from typing import Dict
import os
from .utils import write_source_to_file, append_source_to_file, append_text

logger = logging.getLogger(__name__)


def parse_kitty(config: Dict,
                template: str,
                dest: str,
                theme_name: str) -> Dict:

    logger.info("Loading kitty...")
    dest = os.path.join(dest, "kitty.conf")

    theme_config = os.path.join("themes", theme_name, "kitty", "kitty.conf")

    # copy template file to destination
    if "default_path" in config['kitty']:
        template = config['kitty']['default_path']
    else:
        template = os.path.join(template, "kitty.conf")

    write_source_to_file(template, dest)

    if "fish" in config:
        append_text(dest, "chsh -s /usr/bin/fish\n")

    if "font" in config:
        append_text(dest, f"font_family {config['font']}\n")

    if os.path.exists(theme_config) and theme_config != template:
        append_source_to_file(theme_config, dest)

    return config
