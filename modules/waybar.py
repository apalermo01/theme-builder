import os
import shutil
from typing import Dict
import configparser
import logging


logger = logging.getLogger(__name__)


def parse_waybar(config: Dict,
                  template: dict,
                  dest: dict,
                  theme_name: str):

    # TODO: backup
    waybar_config = config['waybar']

    if 'default_path' in waybar_config:
        assert isinstance(waybar_config['default_path'], dict)
        template['config'] = waybar_config['default_path']['config']
        template['css'] = waybar_config['default_path']['css']
    logger.info(f"copying {template['config']} to {dest['config']}")
    shutil.copy2(template['config'],
                 dest['config'])
    shutil.copy2(template['css'],
                 dest['css'])

    # since polybar uses .ini, we can use the configparser
    # polybar = configparser.ConfigParser()

    # # load template or theme-specific config
    # if os.path.exists(f"./themes/{theme_name}/polybar.ini"):
    #     polybar.read(f"./themes/{theme_name}/polybar.ini")
    #     logger.info("loaded custom polybar config")
    # else:
    #     polybar.read(template)
    #     logger.info("loaded default polybar config")
    # 
    # polybar = _parse_colors(polybar, config)
    # polybar = _init_modules(polybar, config)
    # polybar = _parse_includes(polybar, config, theme_name)
    # polybar = _parse_opts(polybar, config)

    # # write config
    # with open(dest, "w") as f:
    #     polybar.write(f)

    # # launch script
    # src_script = "./scripts/i3wmthemer_bar_launch.sh"
    # dest = "/" + os.path.join(*dest.split('/')[:-1])
    # dest_script = os.path.join(dest, "i3wmthemer_bar_launch.sh")
    # if not os.path.exists(dest):
    #     os.makedirs(dest)
    # with open(dest_script, 'w') as f:
    #     pass
    # shutil.copy2(src_script, dest)

    return config
