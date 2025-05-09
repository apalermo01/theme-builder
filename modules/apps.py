import logging
import os
import subprocess
from typing import Dict, Tuple

from .utils import module_wrapper

logger = logging.getLogger(__name__)


SCHEMA = {
    "name": {
        "description": "name of the theme",
        "type": "string",
    },
    "provides": {
        "description": "list of frameworks that this theme provides",
        "type": "dictionary",
        "properties": {
            "qt": {
                "description": "qt themes",
                "type": "list",
                "options": ["colorscheme", "kvantum"],
            },
            "gtk": {"description": "in progress"},
            "icons": {"description": "in progress"},
            "cursors": {"description": "in progress"},
        },
    },
    "requires": {
        "description": "key-value pairs used to generate the script",
        "type": "dictionary",
        "properties": {
            "qt.colorscheme": {
                "description": "command to run for qt colorscheme. Resolves to 'value <name>'",
                "type": "string",
            },
            "kvantum": {"description": "in progress"},
            "gtk": {"description": "in progress"},
        },
    },
}


@module_wrapper(tool="apps")
def parse_apps(
    config: Dict, theme_path: str, theme_apply_script: str, **kwargs
) -> Tuple[Dict, str]:
    logger.info("Loading apps...")
    apps_config: Dict = config["apps"]
    app_theme_name = apps_config["name"]

    # run any predefined scripts that download theme files and put them
    # in the right place
    installs_path = f"./{theme_path}/apps/"
    for file in os.listdir(installs_path):
        subprocess.call(os.path.join(installs_path, file))
    
    # Now parse through the theme configuration, figure out what we have, and
    # add the correct calls to the theme install script
    for key in apps_config['requires']:
        if key == 'qt.colorscheme':
            theme_apply_script += f"{apps_config['requires'][key]} {app_theme_name}\n"
        elif key in ["kvantum", "gtk"]:
            logger.warning(f"{key} support is in progress, skipping")
            continue
        else:
            logger.error(f"{key} is unsupported, skipping")
            continue

    return config, theme_apply_script
