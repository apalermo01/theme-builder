import logging
import os
from typing import Dict

from .utils import module_wrapper

logger = logging.getLogger(__name__)


@module_wrapper(tool="gtk-4")
def parse_gtk_4(config: Dict, template: str, dest: str, theme_path: str) -> Dict:

    logger.info("Loading gtk-4...")
    return config
