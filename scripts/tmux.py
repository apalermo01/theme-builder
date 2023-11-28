import logging
from typing import Dict

def parse_tmux(config: Dict,
               template: str,
               dest: str,
               theme_name: str) -> Dict:

    if 'tmux' not in config:
        return
    
    with open(template, 'r') as f_out, open(dest, 'w') as f_in:
        for line in f_out.readlines():
            f_in.write(line)
