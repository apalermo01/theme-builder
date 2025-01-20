import logging
import os
from textwrap import dedent
from typing import Dict

# from .utils import append_text, write_source_to_file, append_source_to_file
from .utils import append_text, module_wrapper

logger = logging.getLogger(__name__)


@module_wrapper(tool="bash")
def parse_bash(
    config: Dict, template_dir: str, destination_dir: str, theme_path: str
) -> Dict:

    logger.info("Loading bash...")

    feats = config["bash"].get("feats", [])

    if "wallpaper" in config:
        wallpaper_file = config["wallpaper"]["file"]
        wallpaper_path = os.path.expanduser(f"~/Pictures/wallpapers/{wallpaper_file}")

    prompts_dict = {

        "cowsay_fortune": (
            "fortune | cowsay -f $(ls /usr/share/cowsay/cows/ " "| shuf -n1)\n"
        ),
        "neofetch": "neofetch\n",
        "run_pywal": f"wal -n -e -i {wallpaper_path} > /dev/null \n",
        "git_onefetch": dedent(
            """

                function show_onefetch() {
                    if [ -d .git ]; then
                        onefetch
                    fi
                }
                function cd() { builtin cd "$@" && show_onefetch; }
                \n
            """
        ),
    }
    dest = os.path.join(destination_dir, ".bashrc")

    for d in prompts_dict:
        if d in feats:
            if d == "run_pywal" and wallpaper_path is None:
                logger.error("Cannot add pywal to bash config, no wallpaper")
                continue
            if d == 'neofetch':
                logger.warning("using fastfetch instead of neofetch")
            append_text(dest, prompts_dict[d])

    return config
