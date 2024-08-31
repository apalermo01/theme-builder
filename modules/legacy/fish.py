import logging
import os
from textwrap import dedent
from typing import Dict

logger = logging.getLogger(__name__)


def parse_fish(template: str,
               dest: str,
               config: Dict,
               **kwargs):

    # TODO: backup

    fish_config = config['fish']

    if "default_path" in fish_config:
        logger.warning(f"overwriting template {template} with the one in config: {fist_config['default_path']}")
        template = fish_config['default_path']

    if 'extra_lines' not in fish_config:
        fish_config['extra_lines'] = []

    if fish_config.get('pywal_colors'):
        if 'name' in config['wallpaper']:
            wp_name = config['wallpaper']['name'].split("/")[-1]
        else:
            wp_name = config['wallpaper'].split("/")[-1]

        wallpaper_path = os.path.expanduser(f"~/Pictures/wallpapers/{wp_name}")
        fish_config['extra_lines'].append(dedent(f"""
            wal -n -e -i {wallpaper_path} > /dev/null \n
        """))

    if fish_config.get('git_onefetch'):
        fish_config['extra_lines'].append(dedent("""
                function show_onefetch() {
                    if [ -d .git ]; then
                        onefetch
                    fi
                }
                function cd() { builtin cd "$@" && show_onefetch; }
                \n
            """))

    if fish_config.get('neofetch'):
        fish_config['extra_lines'].append("neofetch\n")

    # write to file
    with open(dest, "w") as f_out, open(template, "r") as f_in:
        for line in f_in.readlines():
            f_out.write(line)

        for line in fish_config['extra_lines']:
            f_out.write(line)

    return config
