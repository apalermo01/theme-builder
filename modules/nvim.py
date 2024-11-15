
import logging
from typing import Dict
import os
from .utils import (module_wrapper,
                    overwrite_or_append_line,
                    )

logger = logging.getLogger(__name__)


@module_wrapper(tool="nvim")
def parse_nvim(template_dir: str,
               destination_dir: str,
               config: Dict,
               theme_name: str):

    logger.info("Loading nvim...")
    nvim_config: Dict = config.get('nvim', {})
