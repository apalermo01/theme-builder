import logging
import os
from textwrap import dedent
from typing import Dict

logger = logging.getLogger(__name__)


def parse_bash(template: str,
               dest: str,
               config: Dict,
               **kwargs):

    # TODO: backup

    bash_config = config['bash']

    if 'extra_lines' not in bash_config:
        bash_config['extra_lines'] = []

    if bash_config.get('pywal_colors'):
        if 'name' in config['wallpaper']:
            wp_name = config['wallpaper']['name'].split("/")[-1]
        else:
            wp_name = config['wallpaper'].split("/")[-1]

        wallpaper_path = os.path.expanduser(f"~/Pictures/wallpapers/{wp_name}")
        bash_config['extra_lines'].append(dedent(f"""
            wal -n -e -i {wallpaper_path} > /dev/null \n
        """))

    if bash_config.get('git_onefetch'):
        bash_config['extra_lines'].append(dedent("""
                function show_onefetch() {
                    if [ -d .git ]; then
                        onefetch
                    fi
                }
                function cd() { builtin cd "$@" && show_onefetch; }
                \n
            """))

    if bash_config.get('neofetch'):
        bash_config['extra_lines'].append("neofetch'\n")

    # write to file
    with open(dest, "w") as f_out, open(template, "r") as f_in:
        for line in f_in.readlines():
            f_out.write(line)

        for line in bash_config['extra_lines']:
            f_out.write(line)

    return config
