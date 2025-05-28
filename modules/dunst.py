import logging
import os
from typing import Dict, Tuple

from .utils import module_wrapper

logger = logging.getLogger(__name__)

@module_wrapper(tool="dunst")
def parse_dunst(
        config: Dict, **kwargs
):
    logger.info("Loading dunst...")


    return config, kwargs['theme_apply_script']
