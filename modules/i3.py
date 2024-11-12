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


@module_wrapper(tool='i3wm')
def parse_i3(template_dir: str,
             dest: str,
             config: Dict,
             theme_name: str):
    """
    Parser for i3
    expects a key for "i3wm" in the theme's config file. If there are files in
        <theme_name>/i3/, then those get copied to the 
    """
    logger.info("configuring i3...")
    logger.info("dest = " + dest)
    # dest = configure_destination(dest, "config")

    # allow theme to overwrite template
    # add terminal option
    _configure_terminal(config, dest, theme_name)
    _configure_colors(config, dest, theme_name)
    _configure_picom(config, dest, theme_name)

    # now copy the config file to the destination directory
    # dest_path = os.path.join(dest, "config")
    # with open(tmp_path, "r") as tmp, open(dest_path, "w") as dest:
    # for line in tmp.readlines():
    # dest.write(line)
    # logger.info(f"copied {tmp_path} to {dest_path}")
    return config


def _configure_terminal(config: Dict, dest: str, theme_name: str):

    terminal: str = 'gnome-terminal'
    for i in available_terminals:
        if i in config:
            terminal = i
            logger.info(
                f"Found {i} in theme's config. Assigning this terminal to $mod+Return")

    if 'terminal' not in config['i3wm']:
        terminal_path = ".config/i3/i3.config"
    else:
        terminal_path = config['i3wm']['terminal'].get(
            'terminal_path', '.config/i3/i3.config')

    terminal_path = os.path.join(
        ".", "themes", theme_name, "dots", terminal_path)

    pattern: str = "bindsym $mod+Return exec"
    replace_text: str = f"bindsym $mod+Return exec {terminal}"

    overwrite_or_append_line(pattern=pattern,
                             replace_text=replace_text,
                             dest=terminal_path)

    logger.info(f"updated terminal: {terminal}")


def _configure_picom(config: Dict, dest: str, theme_name: str):

    if 'picom' not in config:
        return

    dest_path = os.path.join(dest, "i3.config")

    logger.info("picom found in this theme's config")
    append_if_not_present("\nexec killall picom\n", dest_path)
    append_if_not_present(
        "\nexec_always picom --config ~/.config/picom.conf\n", dest_path)


def _configure_colors(config: Dict, dest: str, theme_name: str):
    colorscheme_path: str =\
        os.path.join("themes", theme_name, "colors", "colorscheme.json")

    with open(colorscheme_path, "r") as f:
        colorscheme: Dict = json.load(f)

    colors_file = config['i3wm'].get("i3_write_colors_to", "i3.config")
    dest = os.path.join(dest, colors_file)
    text: List[str] = read_file(dest)

    new_text: List[str] = []

    for line in text:
        for color in colorscheme:
            line = line.replace(f"<{color}>", colorscheme[color])
        new_text.append(line)

    write_file(new_text, dest)
