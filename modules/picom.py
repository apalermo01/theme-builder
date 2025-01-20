import logging
import subprocess
from typing import Dict

from .utils import module_wrapper

logger = logging.getLogger(__name__)


@module_wrapper(tool="picom")
def parse_picom(
    config: Dict, template_dir: str, destination_dir: str, theme_path: str
) -> Dict:

    logger.info("Loading picom...")
    subprocess.run(["killall", "picom"])

    return config
