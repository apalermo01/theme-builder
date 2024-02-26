from typing import Dict, Union, List, Iterable, Tuple
import logging
import os
import shutil
import toml

TMP_PATH = "./tmp/alacritty.toml"
logger = logging.getLogger(__name__)

def parse_alacritty(template: str,
               dest: str,
               config: Dict,
               theme_name: str):

    if "default_path" in config["alacritty"]:
        template = config["alacritty"]["default_path"]
    else:
        template = "./alacritty.toml"

    with open(template, "r") as f:
        alacritty_template = toml.load(f)

    with open(dest, "w") as f:
        _ = toml.dump(alacritty_template, f)
    return config
