import logging
from typing import Dict, Tuple

from .utils import module_wrapper

logger = logging.getLogger(__name__)


@module_wrapper(tool="rofi")
def parse_rofi(
    config: Dict, template_dir: str, destination_dir: str, theme_path: str, **kwargs
) -> Tuple[Dict, str]:

    logger.info("Loading rofi...")
    return config, kwargs['theme_apply_script']
