
import logging
from typing import Dict
import os
from .utils import (module_wrapper,
                    overwrite_or_append_line,
                    )

logger = logging.getLogger(__name__)


@module_wrapper(tool="nvim")
def parse_nvim(template_dir: str,
               destination_dir: str,
               config: Dict,
               theme_path: str):
    """
    Example neovim configs:

    vanilla neovim:
    ```json
    "nvim": {
        "colorscheme": "gruvbox"
    }
    ```

    vanilla neovim pointing the colorscheme to a custom file
    ```json
    "nvim": {
        "colorscheme": {
            "colorscheme": "gruvbox",
            "file": "opt/options.lua"
        }
    }
    ```
    this will place the option for colorscheme inside
    `<home directory>/.config/nvim/opt/options.lua`

    nvchad:
    ```json
    "nvim": {
        "template_dir": "default_configs/nvchad/"
        "nvchad_colorscheme": "gruvbox"
    }
    ```
    """
    logger.info("Loading nvim...")
    nvim_config: Dict = config.get('nvim', {})

    if 'colorscheme' in nvim_config:
        _configure_colorscheme(nvim_config, theme_path)

    if 'nvchad_colorscheme' in nvim_config:
        _configure_nvchad_colorscheme(nvim_config, theme_path)

    if 'nvchad_separator' in nvim_config:
        _configure_nvchad_separator(nvim_config, theme_path)

    return config


def _configure_colorscheme(nvim_config: Dict, theme_path: str):
    if isinstance(nvim_config['colorsheme'], str):
        colorscheme: str = nvim_config['colorscheme']
        colorscheme_path: str = os.path.join(
            ".", "themes", theme_path, "dots", ".config", "nvim", "init.lua"
        )
    else:
        colorscheme: str = nvim_config['colorscheme']['colorscheme']
        colorscheme_path: str = os.path.join(
            ".", "themes", theme_path, "dots", ".config", "nvim",
            nvim_config['colorscheme']['file']
        )
        if not os.path.exists(os.path.split(colorscheme_path)[0]):
            os.makedirs(os.path.split(colorscheme_path)[0])

    cmd: str = f"vim.cmd[[colorscheme {colorscheme}]]"

    overwrite_or_append_line(pattern="vim.cmd[[colorscheme",
                             replace_text=cmd,
                             dest=colorscheme_path)


def _configure_nvchad_colorscheme(nvim_config: Dict, theme_path: str):
    colorscheme: str = nvim_config['nvchad_colorscheme']
    pattern: str = 'theme = "'
    text: str = f'    theme = "{colorscheme}",'
    path: str = os.path.join(
        theme_path, "dots", ".config", "nvim", "lua", "chadrc.lua"
    )
    overwrite_or_append_line(path=path,
                             pattern=pattern,
                             replace_text=text)


def _configure_nvchad_separator(nvim_config: Dict, theme_path: str):
    separator: str = nvim_config['nvchad_separator']
    pattern: str = 'separator_style = "'
    text: str = f'       separator_style = "{separator}",'
    path: str = os.path.join(
        theme_path, "dots", ".config", "nvim", "lua", "chadrc.lua"
    )
    overwrite_or_append_line(path=path,
                             pattern=pattern,
                             replace_text=text)
