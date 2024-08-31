import logging
from typing import Dict, List
import json
# import subprocess
import matplotlib.pyplot as plt
import os

logger = logging.getLogger(__name__)


def parse_colors(
        config: Dict,
        theme_name: str,
        **kwargs
) -> Dict:
    """Function to parse the colorscheme

    Arguments to config:

    - method: "manual"

    TODO:
    add option for pywal
    """

    allowed_methods: List[str] = ['manual']
    method: str = config['colors'].get('method', 'manual')

    if method not in allowed_methods:
        raise ValueError("method not supported. Expected one of: " +
                         allowed_methods + f" but got {method}")

    colorscheme_path: str = os.path.join(
        ".", "themes", theme_name, "colors", "colorscheme.json")

    with open(colorscheme_path, "r") as f:
        colorscheme = json.load(f)
    make_pallet_image(colorscheme)
    return config


def make_pallet_image(pallet: Dict):
    """Generate an image out of all the colors in the pallet.

    Parameters
    ----------
    pallet : Dict
        Dictionary of hex colors
    """

    total_colors = len(pallet)
    nrows = (total_colors + 1) // 2
    ncols = 2
    colors_list = list(pallet.values())
    titles = list(pallet.keys())
    fig, axes = plt.subplots(nrows=nrows, ncols=ncols, figsize=(6, 2 * nrows))
    axes = axes.flatten()
    for i, color in enumerate(colors_list):
        axes[i].set_facecolor(color)
        axes[i].xaxis.set_visible(False)
        axes[i].yaxis.set_visible(False)
        axes[i].set_title(f"{titles[i]}: {color}")
    fig.suptitle("Color Palette", fontsize=14)

    plt.savefig("./tmp/pallet.png", dpi=300, bbox_inches="tight")
