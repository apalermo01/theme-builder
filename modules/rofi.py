import logging
from typing import Dict

from .utils import module_wrapper

logger = logging.getLogger(__name__)


@module_wrapper(tool="rofi")
def parse_rofi(
    config: Dict, template_dir: str, destination_dir: str, theme_path: str
) -> Dict:

    logger.info("Loading rofi...")
    return config
