import logging
import os
from typing import Dict

from .utils import module_wrapper

logger = logging.getLogger(__name__)


@module_wrapper(tool="gtk-3")
def parse_gtk_3(config: Dict, template: str, dest: str, theme_path: str) -> Dict:

    logger.info("Loading gtk-3...")
    return config
