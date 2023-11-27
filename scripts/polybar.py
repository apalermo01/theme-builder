import os
import shutil
from typing import Dict
import configparser

logger = logging.getLogger(__name__)

def parse_polybar(config: Dict,
                  template: str,
                  dest: str,
                  theme_name: str):

    # TODO: backup
    polybar_config = config['polybar']

    # since polybar uses .ini, we can use the configparser
    polybar = configparser.ConfigParser()

    # load template or theme-specific config
    if os.path.exists(f"./themes/{theme_name}/polybar.ini"):
        polybar.read(f"./themes/{theme_name}/polybar.ini")
        logger.info("loaded custom polybar config")
    else:
        polybar.read(template)
        logger.info("loaded default polybar config")
    
    polybar = _parse_colors(polybar, config)
    polybar = _init_modules(polybar, config)
    polybar = _parse_includes(polybar, config, theme_name)
def _parse_colors(polybar: configparser.ConfigParser,
                  config: Dict):
    if 'colors' not in polybar:
        polybar['colors'] = {}

    for c in config['colors']['pallet']:
        polybar['colors'][c] = config['colors']['pallet'][c]

    if 'colors' in config['polybar']:
        for c in config['polybar']['colors']:
            polybar['colors'][c] = config['polybar']['colors'][c]
    
    return polybar

def _init_modules(polybar: configparser.ConfigParser,
                  config: Dict):
    for module in config['polybar']:
        if '/' in module:
            if module not in polybar:
                polybar[module] = {}
    return polybar

def _parse_includes(polybar: configparser.ConfigParser,
                    config: Dict,
                    theme_name: str):

    for key in config['polybar']:
        if "/" in key and "include" in config['polybar'][key]:
            include_path = config['polybar'][key]['include']

            # relative path from project source
            if include_path[0] == '.':
                path = os.path.abspath(include_path)
                logger.info(f"using relative path - pulling module {key} from {path}")
            # module file lives in theme directory
            else:
                path = os.path.abspath(os.path.join('.', 'themes', theme_name, include_path))
                logger.info(f"using theme path - pulling module {key} from {path}")
            polybar[key]['include-file'] = path

    return polybar

def _parse_opts(polybar: configparser.ConfigParser,
                config: Dict):
    for key in config['polybar']:
        if "/" in key and "include" in config['polybar'][key]:
            include_path = config['polybar'][key]['include']

            # relative path from project source
            if include_path[0] == '.':
                path = os.path.abspath(include_path)
                logger.info(f"using relative path - pulling module {key} from {path}")
            # module file lives in theme directory
            else:
                path = os.path.abspath(os.path.join('.', 'themes', theme_name, include_path))
                logger.info(f"using theme path - pulling module {key} from {path}")
            polybar[key]['include-file'] = path

    return polybar
    
