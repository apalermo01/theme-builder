import logging
from typing import Dict
import os

logger = logging.getLogger(__name__)


def parse_tmux(config: Dict,
               template: str,
               dest: str,
               theme_name: str) -> Dict:

    logger.info("Loading tmux...")
    dest = os.path.join(dest, ".tmux.conf")
    # copy template file to destination
    if "default_path" in config['tmux']:
        template = config['tmux']['default_path']
    else:
        template = os.path.join(template, "tmux.conf")

    with open(template, 'r') as f_out, open(dest, 'w') as f_in:
        for line in f_out.readlines():
            f_in.write(line)

    logger.info(f"copied {template} to {dest}")

    # append to destination if there is anything
    # in the theme file
    theme_config = os.path.join("themes", theme_name, "tmux", "tmux.conf")
    if os.path.exists(theme_config):
        with open(theme_config, 'r') as f_out, open(dest, "a") as f_in:
            for line in f_out.readlines():
                f_in.write(line)

        logger.info(f"appended {theme_config} to {dest}")

    return config
