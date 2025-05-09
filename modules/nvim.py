import logging
import os
from typing import Dict

from .utils import module_wrapper, overwrite_or_append_line

logger = logging.getLogger(__name__)


@module_wrapper(tool="nvim")
def parse_nvim(template_dir: str, destination_dir: str, config: Dict, theme_path: str, **kwargs):
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
    nvim_config: Dict = config.get("nvim", {})

    if "colorscheme" in nvim_config:
        _configure_colorscheme(nvim_config, theme_path)

    if "nvchad_colorscheme" in nvim_config:
        _configure_nvchad_colorscheme(nvim_config, theme_path)

    if "nvchad_separator" in nvim_config:
        _configure_nvchad_separator(nvim_config, theme_path)

    if "font_family" in config:
        _configure_font(config['font_family'], theme_path)

    return config, kwargs['theme_apply_script']


def _configure_colorscheme(nvim_config: Dict, theme_path: str):
    if isinstance(nvim_config["colorscheme"], str):
        colorscheme: str = nvim_config["colorscheme"]
        colorscheme_path: str = os.path.join(
            theme_path, "build", "nvim", "init.lua"
        )
    # TODO: need to test this
    else:
        colorscheme: str = nvim_config["colorscheme"]["colorscheme"]
        colorscheme_path: str = os.path.join(
            theme_path, "build", "nvim", nvim_config["colorscheme"]["file"]
        )
        if not os.path.exists(os.path.split(colorscheme_path)[0]):
            os.makedirs(os.path.split(colorscheme_path)[0])

    if not os.path.exists(colorscheme_path):
        raise ValueError(
            f"could not find neovim config file {colorscheme_path} when parsing colorscheme"
        )

    cmd: str = f'vim.cmd.colorscheme("{colorscheme}")'

    overwrite_or_append_line(
        pattern="vim.cmd.colorscheme(", replace_text=cmd, dest=colorscheme_path
    )

def _configure_font(font: str, theme_path: str):
    logger.info("Configuring font")
    path = os.path.join(
        theme_path, "build", "nvim", "init.lua"
    )

    if not os.path.exists(path):
        logger.error(f"Cannot parse font - expected to find {path}")
        return
    c = font.replace(' ', '\ ')
    cmd = f"vim.cmd([[set guifont={c}]])"
    overwrite_or_append_line(
        pattern = "vim.cmd([[set guifont", replace_text=cmd, dest=path
    )


def _configure_nvchad_colorscheme(nvim_config: Dict, theme_path: str):
    colorscheme = nvim_config["nvchad_colorscheme"]
    pattern = 'theme = "'
    text = f'    theme = "{colorscheme}",'
    path = os.path.join(theme_path, "build", "nvim", "lua", "chadrc.lua")
    if not os.path.exists(path):
        raise FileNotFoundError(
            """
            could not find chadrc.lua to configure colorscheme.
            Are you using nvchad? 
            You must pass 'template_dir': 'default_configs/nvim/' 
            in the theme file for this to work."""
        )

    overwrite_or_append_line(dest=path, pattern=pattern, replace_text=text)


def _configure_nvchad_separator(nvim_config: Dict, theme_path: str):
    separator: str = nvim_config["nvchad_separator"]
    pattern: str = 'separator_style = "'
    text: str = f'       separator_style = "{separator}",'
    path: str = os.path.join(theme_path, "build", "nvim", "lua", "chadrc.lua")

    if not os.path.exists(path):
        raise FileNotFoundError(
            """
            could not find chadrc.lua to configure colorscheme.
            Are you using nvchad? 
            You must pass 'template_dir': 'default_configs/nvim/' 
            in the theme file for this to work."""
        )
    overwrite_or_append_line(dest=path, pattern=pattern, replace_text=text)
