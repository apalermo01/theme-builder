import os
import shutil
from typing import Dict
import configparser
import logging


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
    polybar = _parse_opts(polybar, config)

    # write config
    with open(dest, "w") as f:
        polybar.write(f)

    # launch script
    src_script = "./scripts/i3wmthemer_bar_launch.sh"
    dest = "/" + os.path.join(*dest.split('/')[:-1])
    dest_script = os.path.join(dest, "i3wmthemer_bar_launch.sh")
    if not os.path.exists(dest):
        os.makedirs(dest)
    with open(dest_script, 'w') as f:
        pass
    shutil.copy2(src_script, dest)

    return config

def _parse_colors(polybar: configparser.ConfigParser,
                  config: Dict):
    if 'colors' not in polybar:
        polybar['colors'] = {}

    for c in config['colors']['pallet']:
        polybar['colors'][c] = config['colors']['pallet'][c]

    if 'colors' in config['polybar']:
        for c in config['polybar']['colors']:
            print(c)
            if '#' in config['polybar']['colors'][c]:
                polybar['colors'][c] = config['polybar']['colors'][c]
            else:
                color_name = config['polybar']['colors'][c]
                hex_code = config['colors']['pallet'][color_name]
                polybar['colors'][c] = hex_code
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
        if '/' in key:
            for option in config['polybar'][key]:
                if option != 'include':
                    logger.info(f"parsing {key} @ {option}")
                    polybar[key][option] = config['polybar'][key][option]
    return polybar
