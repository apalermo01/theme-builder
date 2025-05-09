# pyright: reportUnusedVariable=false
import logging
import os
from textwrap import dedent
from typing import Dict, Tuple

from .utils import append_text, module_wrapper

logger = logging.getLogger(__name__)


@module_wrapper(tool="zsh")
def parse_zsh(
    config: Dict, template_dir: str, destination_dir: str, theme_path: str, **kwargs
) -> Tuple[Dict, str]:

    logger.info("Loading zsh...")

    feats = config["zsh"].get("feats", [])
    logger.debug(f"feats = {feats}") 

    if "wallpaper" in config:
        wallpaper_file = config["wallpaper"]["file"]
        wallpaper_path = os.path.expanduser(f"~/Pictures/wallpapers/{wallpaper_file}")
    else:
        wallpaper_path = None
    
    prompts_dict = {
        "cowsay_fortune": (
            "fortune | cowsay -r\n"
        ),
        "neofetch": "fastfetch\n",
        "fastfetch": "fastfetch\n",
        "run_pywal": f"wal -n -e -i {wallpaper_path} > /dev/null \n",
        "git_onefetch": dedent(
            """

            function show_onefetch
                if test -d .git
                    onefetch
                end
            end
            
            function cd
                builtin cd $argv
                show_onefetch
            end
            """
        ),
    }
    dest = os.path.join(destination_dir, ".zshrc")
    for d in prompts_dict:
        if d in feats:
            if d == "run_pywal" and wallpaper_path is None:
                logger.error("Cannot add pywal to fish config, no wallpaper")
                continue
            if d == 'neofetch':
                logger.warning("using fastfetch instead of neofetch")
            append_text(dest, prompts_dict[d])
    append_text(dest, '\neval "$(direnv hook zsh)"')
    append_text(dest, '\neval "$(fzf --zsh)"')
    append_text(dest, '\neval "$(zoxide init --cmd cd zsh)"')
    return config, kwargs['theme_apply_script']
