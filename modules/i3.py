from typing import Dict, List
import logging
import os
import json
from . import available_terminals
from .utils import (overwrite_or_append_line,
                    module_wrapper,
                    append_if_not_present,
                    read_file,
                    write_file)

logger = logging.getLogger(__name__)


@module_wrapper(tool='i3')
def parse_i3(template_dir: str,
             destination_dir: str,
             config: Dict,
             theme_path: str):
    """
    Parser for i3
    """
    logger.info("configuring i3...")
    _configure_terminal(config, destination_dir, theme_path)
    _configure_colors(config, destination_dir, theme_path)
    _configure_picom(config, destination_dir, theme_path)

    return config


def _configure_terminal(config: Dict, dest: str, theme_path: str):

    terminal: str = 'gnome-terminal'
    for i in available_terminals:
        if i in config:
            terminal = i
            logger.info(
                f"Found {i} in theme's config. " +
                "Assigning this terminal to $mod+Return")

    if 'terminal' not in config['i3']:
        terminal_path = ".config/i3/config"
    else:
        terminal_path = config['i3']['terminal'].get(
            'terminal_path', '.config/i3/config')

    terminal_path = os.path.join(
        theme_path, "dots", terminal_path)

    pattern: str = "bindsym $mod+Return exec"
    replace_text: str = f"bindsym $mod+Return exec {terminal}"

    overwrite_or_append_line(pattern=pattern,
                             replace_text=replace_text,
                             dest=terminal_path)

    logger.info(f"updated terminal: {terminal}")


def _configure_picom(config: Dict, dest: str, theme_path: str):

    if 'picom' not in config:
        return

    dest_path = os.path.join(dest, "config")

    logger.info("picom found in this theme's config")
    append_if_not_present("\nexec killall picom\n", dest_path)
    append_if_not_present(
        "\nexec_always picom --config ~/.config/picom.conf\n", dest_path)


def _configure_colors(config: Dict, dest: str, theme_path: str):
    colorscheme_path: str =\
        os.path.join(theme_path, "colors", "colorscheme.json")

    with open(colorscheme_path, "r") as f:
        colorscheme: Dict = json.load(f)

    colors_file = config['i3'].get("i3_write_colors_to", "config")
    dest = os.path.join(dest, colors_file)
    text: List[str] = read_file(dest)

    new_text: List[str] = []

    for line in text:
        for color in colorscheme:
            line = line.replace(f"<{color}>", colorscheme[color])
        new_text.append(line)

    write_file(new_text, dest)
