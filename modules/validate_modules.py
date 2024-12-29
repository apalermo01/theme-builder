import os
from typing import Dict
import logging

logger = logging.getLogger(__name__)


def validate_polybar(config: Dict, theme_path: str):
    polybar_path: str = os.path.join(
        theme_path, "polybar", "polybar.ini")
    if not os.path.exists(polybar_path):
        logger.critical(f"Polybar needs a custom config in {polybar_path}")
        return False, {}

    if 'copy' not in config['polybar']:
        config['polybar']['copy'] = [{
            'to': '.config/polybar/polybar.ini',
            'from': 'polybar.ini'
        }]
    return True, config
