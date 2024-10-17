from typing import Dict, List
import logging
import os
import json
from .utils import append_source_to_file, append_text


TMP_PATH = "./tmp/hyprland.conf"
logger = logging.getLogger(__name__)


def parse_hyprland(template: str,
                   dest: str,
                   config: Dict,
                   theme_name: str):
    """
    TODO: validate variables. For example, check if a terminal is passed to
    hyprland that is not present in the wider config.
    """

    logger.info("configuring hyprland...")

    # allow theme to overwrite template
    theme_path = os.path.join(
        ".", "themes", theme_name)

    if "default_path" in config['hyprland']:
        template: str = config['hyprland']['default_path']
    else:
        template = os.path.join(template, "hyprland.conf")

    with open(TMP_PATH, 'w') as f:
        f.write("# generated using hyprland.py in dotfiles project\n\n")

    # copy template into temp file
    _configure_variables(config)

    with open(template, "r") as f_in, open(TMP_PATH, "a") as f_out:
        for line in f_in.readlines():
            f_out.write(line)

    _configure_general(theme_path)
    _configure_decoration(theme_path)
    _configure_animations(theme_path)

    _configure_colors(theme_name)

    if os.path.exists(os.path.join(theme_path, "hyprland.conf")):
        pass

    # now copy the config file to the destination directory
    dest_path = os.path.join(dest, "hyprland.conf")
    with open(TMP_PATH, "r") as tmp, open(dest_path, "w") as dest:
        for line in tmp.readlines():
            dest.write(line)
    logger.info(f"copied {TMP_PATH} to {dest_path}")
    return config


def _configure_variables(config: Dict):
    term = config['hyprland'].get('terminal', 'kitty')
    file_manager = config['hyprland'].get('fileManager', 'thunar')
    browser = config['hyprland'].get('browser', 'firefox')
    menu = config['hyprland'].get('menu', 'wofi --show drun')

    append_text(TMP_PATH, f"$terminal = {term}\n")
    append_text(TMP_PATH, f"$fileManager = {file_manager}\n")
    append_text(TMP_PATH, f"$browser = {browser}\n")
    append_text(TMP_PATH, f"$menu = {menu}\n")


def _configure_general(theme_path: str):
    src = os.path.join(theme_path, "hyprland", "general.conf")
    if not os.path.exists(src):
        src = os.path.join("./default_configs", "hyprland", "general.conf")
    logger.info(f"loading general.conf from {src}")
    append_source_to_file(src, TMP_PATH)


def _configure_decoration(theme_path: str):
    src = os.path.join(theme_path, "hyprland", "decoration.conf")
    if not os.path.exists(src):
        src = os.path.join("./default_configs", "hyprland", "decoration.conf")
    logger.info(f"loading decoration.conf from {src}")
    append_source_to_file(src, TMP_PATH)


def _configure_animations(theme_path: str):
    src = os.path.join(theme_path, "hyprland", "animations.conf")
    print("custom animations path: ", src)
    if not os.path.exists(src):
        src = os.path.join("./default_configs", "hyprland", "animations.conf")
    logger.info(f"loading annimations.conf from {src}")
    append_source_to_file(src, TMP_PATH)


def _configure_colors(theme_name: str):
    colorscheme_path: str = os.path.join(
        '.', 'themes', theme_name, 'colors', 'colorscheme.json')
    if not os.path.exists(colorscheme_path):
        raise FileNotFoundError(f"could not find {colorscheme_path}")

    with open(colorscheme_path, "r") as f:
        colorscheme: Dict = json.load(f)

    print(f"opening tmp file from {TMP_PATH}")
    with open(TMP_PATH, "r") as f:
        config: List = f.readlines()

    new_lines: List[str] = []
    # print("parsing colors")
    for line in config:
        # print(f"line = {line}")
        for colorname in colorscheme:
            color: str = colorscheme[colorname].replace("#", '')
            line = line.replace(f"<{colorname}>", f"rgb({color})")
        # print("new line = ", line)
        new_lines.append(line)

    with open(TMP_PATH, "w") as f:
        f.writelines(new_lines)
