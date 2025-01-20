import logging
import os
from typing import Dict

from .utils import module_wrapper

logger = logging.getLogger(__name__)


@module_wrapper(tool="tmux")
def parse_tmux(
    config: Dict, template_dir: str, destination_dir: str, theme_path: str
) -> Dict:

    logger.info("Loading tmux...")

    # put the run command for tpm at the very bottom
    with open(os.path.join(destination_dir, ".tmux.conf"), "a") as f:
        f.write("run '~/.tmux/plugins/tpm/tpm'")

    return config
