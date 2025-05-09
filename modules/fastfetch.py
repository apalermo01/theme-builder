import logging
from typing import Dict, Tuple
import os
from .utils import module_wrapper
logger = logging.getLogger(__name__)

@module_wrapper(tool='fastfetch')
def parse_fastfetch(config: Dict,
                    **kwargs) -> Tuple[Dict, str]:

    logger.info("Loading fastfetch...")
    return config, kwargs['theme_apply_script']
