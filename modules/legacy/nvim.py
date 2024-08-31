
from typing import Dict, List, Iterable, Tuple
import os
import logging
import shutil
import subprocess
logger = logging.getLogger(__name__)

TMP_PATH = "./tmp/.tmp_init.lua"


def _read_tmp() -> List:
    with open(TMP_PATH, "r") as f:
        lines = f.readlines()
    return lines


def _write_tmp(text: List[str]):
    with open(TMP_PATH, "w") as f:
        f.writelines(text)


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


def _overwrite_or_append_block(
    pattern: str,
    end_pattern: str,
    replace_text: str,
):

    config_text = _read_tmp()
    new_text = []

    config_text, new_text = _iterate_until_text(iter(config_text),
                                                new_text,
                                                pattern,
                                                append_target=False)
    # TODO: add everything in replace_text, then loop config_text until
    # end_pattern, then add the rest of config_text


def parse_nvim(template: str,
               dest: str,
               config: Dict,
               theme_name: str):

    logger.info("starting to parse nvim config")
    nvim_config = config.get('nvim', {})

    if 'default_path' in nvim_config:
        template = nvim_config['default_path']
    logger.info(f"template path: {template}")
    logger.info(f"dest path: {dest}")
    with open(template, "r") as f_out, open(dest, "w") as f_in:
        for line in f_out.readlines():
            f_in.write(line)

    return config


def _configure_colorscheme(nvim_config):

    colorscheme = nvim_config.get('colorscheme', 'gruvbox')
    _overwrite_or_append_line(pattern='vim.cmd[[colorscheme',
                              replace_text=f'vim.cmd[[colorscheme {colorscheme}]]')


def _configure_lualine(nvim_config):
    lualine_cfg = nvim_config.get("lualine")
    if lualine_cfg is None:
        return
