import os
import subprocess
from typing import Dict
import shutil
import logging


logger = logging.getLogger(__name__)

def parse_picom(theme_name: str,
                dest: str):

    # kill picom if its already running
    subprocess.run(['killall', 'picom'])
    theme_path = os.path.join(".", "themes", theme_name, "picom.conf")

    if os.path.exists(theme_path):
        logger.info("found picom.conf")
        shutil.copy(src=theme_path, dst=dest)
    return config
