import logging
import os
from typing import Dict, Tuple

from .utils import append_text, module_wrapper

logger = logging.getLogger(__name__)


@module_wrapper(tool="kitty")
def parse_kitty(
    config: Dict, template_dir: str, destination_dir: str, theme_path: str, **kwargs
) -> Tuple[Dict, str]:

    logger.info("Loading kitty...")

    if "fish" in config:
        append_text(
            os.path.join(destination_dir, "kitty.conf"), "chsh -s /usr/bin/fish\n"
        )

    if "font_family" in config or os.environ['FONT']:

        if os.environ['FONT']:
            font = os.environ['FONT']
        else:
            font = config['font_family']
        append_text(
            os.path.join(destination_dir, "kitty.conf"),
            f"font_family   family=\"{font}\"\n",
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

    if 'font_size' in config or os.environ.get('FONTSIZEPX'):
        if os.environ.get('FONTSIZEPX'):
            font_size = os.environ['FONTSIZEPX']
        else:
            font_size = config['font_size']
        append_text(
            os.path.join(destination_dir, "kitty.conf"),
            f"font_size     {font_size}\n",
        )
        


    return config, kwargs['theme_apply_script']
