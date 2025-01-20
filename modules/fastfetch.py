import logging
from typing import Dict
import os
from .utils import module_wrapper
logger = logging.getLogger(__name__)

@module_wrapper(tool='fastfetch')
def parse_fastfetch(config: Dict,
                    template_dir: str,
                    destination_dir: str,
                    theme_path: str) -> Dict:

    logger.info("Loading fastfetch...")
    return config
