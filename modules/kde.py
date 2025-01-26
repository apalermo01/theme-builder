import os 
import subprocess 
import logging 

logger = logging.getLogger(__name__)

def parse_kde(config: dict, *args, **kwargs):
    
    logger.info("Loading kde...")

    script = config['kde']['script']

    if script == 'catppuccin': 
        subprocess.call("./scripts/catppuccin_kde.sh")
    return config
