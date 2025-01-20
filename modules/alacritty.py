import logging
import os
from typing import Dict

from .utils import module_wrapper

logger = logging.getLogger(__name__)


@module_wrapper(tool="alacritty")
def parse_alacritty(config: Dict, template: str, dest: str, theme_path: str) -> Dict:

    logger.info("Loading alacritty...")
    return config
