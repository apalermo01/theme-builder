import logging
from typing import Dict

def parse_tmux(config: Dict,
               template: str,
               dest: str,
               theme_name: str) -> Dict:

    if "default_path" in config['tmux']:
        template = config['tmux']['default_path']

    with open(template, 'r') as f_out, open(dest, 'w') as f_in:
        for line in f_out.readlines():
            f_in.write(line)
