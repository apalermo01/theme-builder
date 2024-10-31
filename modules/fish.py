import logging
from typing import Dict
import os
from .utils import append_text, write_source_to_file, append_source_to_file
from textwrap import dedent

logger = logging.getLogger(__name__)


def parse_fish(config: Dict,
               template: str,
               # dest: str,
               theme_name: str) -> Dict:

    logger.info("Loading fish...")

    wallpaper_file = config['wallpaper']['file']
    feats = config['fish'].get('feats', [])
    wallpaper_path = os.path.expanduser(
        f"~/Pictures/wallpapers/{wallpaper_file}")

    prompts_dict = {
        'cowsay_fortune': ("fortune | cowsay -f $(ls /usr/share/cowsay/cows/ "
                           "| shuf -n1)\n"),
        'neofetch': "neofetch\n",
        'run_pywal': f"wal -n -e -i {wallpaper_path} > /dev/null \n",
        "git_onefetch": dedent("""
            function show_onefetch
                if test -d .git
                    onefetch
                end
            end
            
            function cd
                builtin cd $argv
                show_onefetch
            end
            """)
    }
    # dest = os.path.join(dest, "config.fish")
    dest = os.path.join("themes", theme_name, "dotifles", "fish", "config.fish")
    theme_config = os.path.join("themes", theme_name, "fish", "config.fish")

    # copy template file to destination
    if "default_path" in config['fish']:
        template = config['fish']['default_path']
    else:
        template = os.path.join(template, "config.fish")

    write_source_to_file(template, dest)

    if os.path.exists(theme_config):
        append_source_to_file(theme_config, dest)

    for d in prompts_dict:
        if d in feats:
            append_text(dest, prompts_dict[d])
    return config
