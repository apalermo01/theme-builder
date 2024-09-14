import logging
from typing import Dict
import os
from .utils import write_source_to_file, append_source_to_file

logger = logging.getLogger(__name__)

TMP_PATH = "./tmp/tmux.conf"


def parse_tmux(config: Dict,
               template: str,
               dest: str,
               theme_name: str) -> Dict:

    logger.info("Loading tmux...")
    dest = os.path.join(dest, ".tmux.conf")
    theme_config = os.path.join("themes", theme_name, "tmux", "tmux.conf")

    # copy template file to destination
    if "default_path" in config['tmux']:
        template = config['tmux']['default_path']
    else:
        template = os.path.join(template, "tmux.conf")

    write_source_to_file(template, TMP_PATH)

    if os.path.exists(theme_config):
        append_source_to_file(theme_config, TMP_PATH)

    # final tpm install bit 
    with open(TMP_PATH, "a") as f:
        f.write("run '~/.tmux/plugins/tpm/tpm'")

    write_source_to_file(TMP_PATH, dest)
    # default_parser(template, dest, theme_config, theme_name)
    return config
