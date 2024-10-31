import logging
from typing import Dict
import os
from .utils import append_text, write_source_to_file, append_source_to_file
from textwrap import dedent

logger = logging.getLogger(__name__)


def parse_bash(config: Dict,
               template: str,
               # dest: str,
               theme_name: str) -> Dict:

    logger.info("Loading bash...")

    wallpaper_file = config['wallpaper']['file']
    feats = config['bash'].get('feats', [])
    wallpaper_path = os.path.expanduser(
        f"~/Pictures/wallpapers/{wallpaper_file}")

    prompts_dict = {
        'cowsay_fortune': ("fortune | cowsay -f $(ls /usr/share/cowsay/cows/ "
                           "| shuf -n1)\n"),
        'neofetch': "neofetch\n",
        'run_pywal': f"wal -n -e -i {wallpaper_path} > /dev/null \n",
        "git_onefetch": dedent("""
                function show_onefetch() {
                    if [ -d .git ]; then
                        onefetch
                    fi
                }
                function cd() { builtin cd "$@" && show_onefetch; }
                \n
            """)
                }
    # dest = os.path.join(dest, ".bashrc")
    dest = f"./themes/{theme_name}/dotfiles/.bashrc"
    theme_config = os.path.join("themes", theme_name, "bash", ".bashrc")

    # copy template file to destination
    if "default_path" in config['bash']:
        template = config['bash']['default_path']
    else:
        template = os.path.join(template, ".bashrc")

    write_source_to_file(template, dest)

    if os.path.exists(theme_config):
        append_source_to_file(theme_config, dest)

    for d in prompts_dict:
        if d in feats:
            append_text(dest, prompts_dict[d])
    return config
