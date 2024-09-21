from typing import Dict, List, Iterable, Tuple
import logging
import os
import json
from . import available_terminals


TMP_PATH = "./tmp/hyprland.conf"
logger = logging.getLogger(__name__)


def parse_hyprland(template: str,
                   dest: str,
                   config: Dict,
                   theme_name: str):

    logger.info("configuring hyprland...")

    # allow theme to overwrite template
    theme_path = os.path.join(
        ".", "themes", theme_name, "hyprland")


    if "default_path" in config['hyprland']:
        template: str = config['hyprland']['default_path']
    else:
        template = os.path.join(template, "hyprland.conf")

    # copy template into temp file
    with open(template, "r") as f_in, open(TMP_PATH, "w") as f_out:
        for line in f_in.readlines():
            f_out.write(line)

    _configure_terminal(config)
    _configure_general(theme_path)
    _configure_decoration(theme_path)
    _configure_animations(theme_path)

    if os.path.exists(os.path.join(theme_path, "hyprland.conf")):
        pass

    # now copy the config file to the destination directory
    dest_path = os.path.join(dest, "hyprland.conf")
    with open(TMP_PATH, "r") as tmp, open(dest_path, "w") as dest:
        for line in tmp.readlines():
            dest.write(line)
    logger.info(f"copied {TMP_PATH} to {dest_path}")
    return config


def _configure_terminal(config: Dict):
    pass


def _configure_general(theme_path: str):
    if os.path.exists(os.path.join(theme_path, "hyprland", "general.conf")):
        pass


def _configure_decoration(theme_path: str):
    if os.path.exists(os.path.join(theme_path, "hyprland", "decoration.conf")):
        pass


def _configure_animations(theme_path: str):
    if os.path.exists(os.path.join(theme_path, "hyprland", "animations.conf")):
        pass
