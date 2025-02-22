import json
import logging
import os
from typing import Dict, List

from .utils import (append_if_not_present, module_wrapper,
                    overwrite_or_append_line, read_file, write_file)
from .validate_modules import available_terminals

logger = logging.getLogger(__name__)


@module_wrapper(tool="i3")
def parse_i3(template_dir: str, destination_dir: str, config: Dict, theme_path: str):
    """
    Parser for i3
    """
    logger.info("configuring i3...")
    _configure_terminal(config, destination_dir, theme_path)
    _configure_picom(config, destination_dir, theme_path)

    return config


def _configure_terminal(config: Dict, dest: str, theme_path: str):

    terminal: str = "gnome-terminal"

    # check the theme config for a terminal. If it is specified, then 
    # start that using $mod+Return in i3
    for i in available_terminals:
        if i in config:
            terminal = i
            logger.info(
                f"Found {i} in theme's config. "
                + "Assigning this terminal to $mod+Return"
            )
    
    # TODO: why am I handling terminal path like this?
    if "terminal" not in config["i3"]:
        terminal_path = "i3/config"
    else:
        terminal_path = config["i3"]["terminal"].get("terminal_path", "i3/config")

    terminal_path = os.path.join(theme_path, "build", terminal_path)

    pattern: str = "bindsym $mod+Return exec"
    replace_text: str = f"bindsym $mod+Return exec {terminal}"

    overwrite_or_append_line(
        pattern=pattern, replace_text=replace_text, dest=terminal_path
    )

    logger.info(f"updated terminal: {terminal}")


def _configure_picom(config: Dict, dest: str, theme_path: str):

    if "picom" not in config:
        return

    dest_path = os.path.join(dest, "config")

    logger.info("picom found in this theme's config")
    append_if_not_present("\nexec killall picom\n", dest_path)
    append_if_not_present(
        "\nexec_always picom --backend glx --config ~/.config/picom/picom.conf\n", dest_path
    )
