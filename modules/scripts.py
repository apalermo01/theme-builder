import logging
from typing import Dict
import os
import subprocess

logger = logging.getLogger(__name__)


def parse_scripts(config: Dict,
                  theme_path: str,
                  **kwargs) -> Dict:

    logger.info("Running theme config scripts")
    path = config['scripts']['path']
    for file in os.listdir(path):
        subprocess.call(os.path.join(path, file))
    return config
