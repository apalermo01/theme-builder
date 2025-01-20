import json
import logging
import os
from typing import Dict, List

from .utils import append_source_to_file, append_text, module_wrapper

# TMP_PATH = "./tmp/hyprland.conf"
logger = logging.getLogger(__name__)


@module_wrapper(tool="hyprland")
def parse_hyprland(
    template_dir: str, destination_dir: str, config: Dict, theme_path: str
):
    """
    TODO: validate variables. For example, check if a terminal is passed to
    hyprland that is not present in the wider config.
    """

    logger.info("configuring hyprland...")

    # copy template into temp file
    _configure_variables(config, destination_dir, theme_path)
    _configure_general(config, destination_dir, theme_path)
    _configure_decoration(config, destination_dir, theme_path)
    _configure_animations(config, destination_dir, theme_path)
    _configure_colors(config, destination_dir, theme_path)

    return config


def _configure_variables(config: Dict, destination_dir: str, theme_path: str):
    term = config["hyprland"].get("terminal", "kitty")
    file_manager = config["hyprland"].get("fileManager", "thunar")
    browser = config["hyprland"].get("browser", "firefox")
    menu = config["hyprland"].get("menu", "wofi --show drun")

    path = os.path.join(destination_dir, "hyprland.conf")
    append_text(path, f"$terminal = {term}\n")
    append_text(path, f"$fileManager = {file_manager}\n")
    append_text(path, f"$browser = {browser}\n")
    append_text(path, f"$menu = {menu}\n")


def _configure_general(config: Dict, destination_dir: str, theme_path: str):
    write_path = os.path.join(destination_dir, "hyprland.conf")
    src = os.path.join(theme_path, "hypr", "general.conf")
    if not os.path.exists(src):
        src = os.path.join("./default_configs", "hyprland", "general.conf")

    logger.info(f"loading general.conf from {src}")
    append_source_to_file(src, write_path)

    if os.path.exists(os.path.join(destination_dir, "general.conf")):
        os.remove(os.path.join(destination_dir, "general.conf"))
        logger.info(
            f"removed {os.path.join(destination_dir, 'general.conf')} due to redundancy"
        )


def _configure_decoration(config: Dict, destination_dir: str, theme_path: str):
    write_path = os.path.join(destination_dir, "hyprland.conf")
    src = os.path.join(theme_path, "hypr", "decoration.conf")
    if not os.path.exists(src):
        src = os.path.join("./default_configs", "hyprland", "decoration.conf")

    logger.info(f"loading decoration.conf from {src}")
    append_source_to_file(src, write_path)

    if os.path.exists(os.path.join(destination_dir, "decoration.conf")):
        os.remove(os.path.join(destination_dir, "decoration.conf"))
        logger.info(
            f"removed {os.path.join(destination_dir, 'decoration.conf')} due to redundancy"
        )


def _configure_animations(config: Dict, destination_dir: str, theme_path: str):

    write_path = os.path.join(destination_dir, "hyprland.conf")
    src = os.path.join(theme_path, "hypr", "animations.conf")
    if not os.path.exists(src):
        src = os.path.join("./default_configs", "hyprland", "animations.conf")

    logger.info(f"loading animations.conf from {src}")
    append_source_to_file(src, write_path)

    if os.path.exists(os.path.join(destination_dir, "animations.conf")):
        os.remove(os.path.join(destination_dir, "animations.conf"))
        logger.info(
            f"removed {os.path.join(destination_dir, 'animations.conf')} due to redundancy"
        )


def _configure_colors(config: Dict, destination_dir: str, theme_path: str):
    colorscheme_path: str = os.path.join(theme_path, "colors", "colorscheme.json")
    if not os.path.exists(colorscheme_path):
        raise FileNotFoundError(f"could not find {colorscheme_path}")

    with open(colorscheme_path, "r") as f:
        colorscheme: Dict = json.load(f)

    config_path = os.path.join(destination_dir, "hyprland.conf")
    print(f"opening tmp file from {config_path}")
    with open(config_path, "r") as f:
        config: List = f.readlines()

    new_lines: List[str] = []
    for line in config:
        # print(f"line = {line}")
        for colorname in colorscheme:
            color: str = colorscheme[colorname].replace("#", "")
            line = line.replace(f"<{colorname}>", f"rgb({color})")
        # print("new line = ", line)
        new_lines.append(line)

    with open(config_path, "w") as f:
        f.writelines(new_lines)
