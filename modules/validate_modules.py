import logging
import os
from typing import Dict

logger = logging.getLogger(__name__)

available_terminals = ["kitty", "alacritty"]
available_wms = ["i3wm"]
available_bars = ["polybar"]
available_shells = ["fish", "bash"]
available_nvim_distros = ["nvim", "nvchad"]

allowed_elements = {
    "terminals": available_terminals,
    "wms": available_wms,
    "bars": available_bars,
    "shells": available_shells,
    "nvim_distros": available_nvim_distros,
}


def validate_polybar(config: Dict, theme_path: str):
    polybar_path: str = os.path.join(theme_path, "polybar", "config.ini")
    if not os.path.exists(polybar_path):
        logger.critical(f"Polybar needs a custom config in {polybar_path}")
        return False, {}

    if "overwrite" not in config["polybar"]:
        config["polybar"]["overwrite"] = [
            {"to": "polybar/config.ini", "from": "config.ini"}
        ]

    return True, config
