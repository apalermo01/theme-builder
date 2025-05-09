import configparser
import logging
from typing import Dict, Tuple
import os
from .utils import module_wrapper

logger = logging.getLogger(__name__)

SCHEMA = {
    "template_dir": {
        "description": "where to read the default okular config",
        "type": "path",
        "default": "./default_configs/okular/okularrc",
    }
}


@module_wrapper(tool="okular")
def parse_okular(config, theme_path, **kwargs) -> Tuple[Dict, str]:

    logger.info("Loading okular...")
    okular = configparser.ConfigParser()

    # ensure case gets preserved
    okular.optionxform = lambda option: option

    okular.read(
        config["okular"].get("template_dir", "./default_configs/okular/okularrc")
    )
    destination_dir = os.path.join(
        theme_path, "build", "okular", "okularrc"
    )

    if "apps" in config:
        app_theme_name: str = config["apps"]["name"]
        if 'UiSettings' not in okular:
            okular['UiSettings'] = {}
        okular['UiSettings']['ColorScheme'] = app_theme_name
        with open(destination_dir, "w") as f:
            okular.write(f)

    return config, kwargs["theme_apply_script"]
