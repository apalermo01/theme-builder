import logging
import os
import shutil
from typing import Dict, Tuple

from .utils import module_wrapper

logger = logging.getLogger(__name__)


# @module_wrapper(tool="global")
def parse_global(
    config: Dict, theme_path: str, template_dir: str, **kwargs
) -> Tuple[Dict, str]:

    logger.info("Loading global settings...")
    if 'wsl' not in theme_path:
        parse_profile(config, template_dir, theme_path)
    else:
        logger.info("wsl detected, not parsing profile")

    return config, kwargs["theme_apply_script"]

def parse_profile(config, template_dir, theme_path):
    if "global" in config:
        profile_src: str = config["global"].get(
            "template_dir", os.path.join(template_dir, "profile")
        )
    else:
        profile_src: str = os.path.join("./", template_dir, "profile")
    profile_dst: str = os.path.join("./", theme_path, "build", "global", ".profile")

    # set up profile
    shutil.copy2(src=profile_src, dst=profile_dst)
    logger.info(f"{profile_src} -> {profile_dst}")
