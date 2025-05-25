import logging
import os
from typing import Dict, Tuple
import toml
from .utils import module_wrapper

logger = logging.getLogger(__name__)


@module_wrapper(tool="yazi")
def parse_yazi(
    config: Dict, template_dir: str, destination_dir: str, theme_path: str, **kwargs
) -> Tuple[Dict, str]:

    logger.info("Loading yazi...")

    if 'dark' not in config['yazi'] or 'light' not in config['yazi']:
        return config, kwargs['theme_apply_script']

    yazi_theme_path: str = os.path.join(theme_path, 'build', 'yazi/theme.toml')
    if os.path.exists(yazi_theme_path):
        yazi_cfg = toml.load(yazi_theme_path)
        # with open(yazi_theme_path, "rb") as f:
    else:
        yazi_cfg = {}


    if 'flavor' not in yazi_cfg:
        yazi_cfg['flavor'] = {}
    

    if 'dark' in config['yazi']:
        yazi_cfg['flavor']['dark'] = config['yazi']['dark']
    if 'light' in config['yazi']:
        yazi_cfg['flavor']['light'] = config['yazi']['light']
    
    # toml.dump
    with open(yazi_theme_path, "w") as f:
        toml.dump(yazi_cfg, f)

    return config, kwargs['theme_apply_script']
