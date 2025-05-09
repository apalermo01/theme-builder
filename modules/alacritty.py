import logging
import os
from typing import Dict, Tuple

from .utils import module_wrapper

logger = logging.getLogger(__name__)


@module_wrapper(tool="alacritty")
def parse_alacritty(config: Dict, **kwargs) -> Tuple[Dict, str]:

    logger.info("Loading alacritty...")
    return config, kwargs['theme_apply_script']
