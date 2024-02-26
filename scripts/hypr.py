from typing import Dict, Union, List, Iterable, Tuple
import logging
import os
import shutil
from . fileutils import configure_other_files

TMP_PATH = "./tmp/hyprland.conf"
logger = logging.getLogger(__name__)

def parse_hypr(template: str,
               dest: str,
               config: Dict,
               theme_name: str):

    # allow config to overwrite default files
    if "default_path" in config['hypr']:
        template = config['hypr']['default_path']

    if 'other_files' in config['hypr']:
        configure_other_files(config['hypr']['other_files'])

    logger.info(f"pulling hyperland template from {template}")

    with open(template, "r") as f_in, open(TMP_PATH, "w") as f_out:
        for line in f_in.readlines():
            f_out.write(line)

    with open(TMP_PATH, "r") as f_in, open(dest, "w") as f_out:
       for r in f_in.readlines():
           f_out.write(r)

    logger.info(f"wrote to final directory: {dest}")

    return config

