from typing import Dict, List, Iterable, Tuple
import os
import logging
import shutil
logger = logging.getLogger(__name__)

TMP_PATH = "./tmp/.vimrc"

def _read_tmp() -> List:
    with open(TMP_PATH, "r") as f:
        lines = f.readlines()
    return lines

def _write_tmp(text: List[str]):
    with open(TMP_PATH, "w") as f:
        f.writelines(text)

def parse_vim(template: str,
              dest: str,
              config: Dict,
              theme_name: str):


    logger.info("starting to parse vimrc")
    vim_config = config.get('vim', {})

    # copy template into temp file
    with open(template, "r") as f_out, open(TMP_PATH, "w") as f_in:
        for line in f_out.readlines():
            f_in.write(line)

    # color_file = vim_config.get('color_file', 'gruvbox')
    # colorscheme = vim_config.get('colorscheme', 'gruvbox')
    # airline_theme  = vim_config.get('airline_theme', 'dark')
    # plugs = vim_config.get('plugs', [])
    # extra_lines = vim_config.get('extra_lines', [])

    # logger.info(f"color_file = {color_file}")
    # logger.info(f"colorscheme = {colorscheme}")
    # 
    # # logging extra plugs and lines
    # if len(plugs) > 0:
    #     logger.info("Plugs:")
    #     for p in plugs:
    #         logger.info(p)
    #     logger.info("end vim plugs")

    # if len(extra_lines) > 0:
    #     logger.info("extra lines for vimrc:")
    #     for l in extra_lines:
    #         logger.info(l)
    #     logger.info("end extra lines for vim")

    _configure_plugs(vim_config)
    _configure_colorscheme(vim_config)
    _configure_colorsfile(vim_config, theme_name, dest)
    _configure_airline_theme(vim_config)
    _configure_settings(vim_config)
    shutil.copy(src=TMP_PATH, dst=dest)
    return config

def _iterate_until_text(text: Iterable[str],
                        new_text: List[str],
                        target_text: str,
                        append_target: bool = True,
                        ) -> Tuple[Iterable[str], List[str]]:
    for t in text:
        if target_text in t:
            if append_target:
                new_text.append(t)
            break
        new_text.append(t)
    return text, new_text

def _overwrite_or_append_line(
        pattern: str,
        replace_text: str,
        ):
    config_text = _read_tmp()
    new_text = []

    config_text, new_text = _iterate_until_text(iter(config_text),
                                                new_text,
                                                pattern,
                                                append_target=False)
    new_text.append(f"{replace_text}\n")
    for t in config_text:
        new_text.append(t)

    _write_tmp(new_text)

def _configure_plugs(vim_config: Dict):
    new_text = []
    config_text, new_text = _iterate_until_text(iter(_read_tmp()), new_text, "call plug#begin(")

    for p in vim_config.get('plugs', []):
        new_text.append(f"Plug '{p}'\n")

    for t in config_text:
        new_text.append(t)

    _write_tmp(new_text)

def _configure_colorscheme(vim_config: Dict):

    colorscheme = vim_config.get('colorscheme', 'gruvbox')
    _overwrite_or_append_line(pattern='colorscheme ',
                             replace_text=f'colorscheme {colorscheme}')

def _configure_colorsfile(vim_config: Dict,
                          theme_name: str,
                          dest: str):
    colors_file = vim_config.get('colors_file')
    if colors_file is None:
        return

    colors_path = f"./themes/{theme_name}/{colors_file}"
    colors_dest = os.path.join(dest, "colors", colors_file)

    shutil.copy(src=colors_path, dst=colors_dst)

def _configure_airline_theme(vim_config: Dict):

    airline_theme = vim_config.get('airline_theme', 'gruvbox')
    _overwrite_or_append_line(pattern='let g:airline_theme=',
                              replace_text=f'let g:airline_theme="{airline_theme}"')

def _configure_settings(vim_config: Dict):
    for setting in vim_config.get('settings', []):
        _overwrite_or_append_line(pattern=setting,
                                  replace_text=f"{setting}{vim_config['settings'][setting]}")
