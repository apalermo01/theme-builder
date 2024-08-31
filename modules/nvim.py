import logging
from typing import List, Iterable, Tuple, Dict
import os
import shutil
logger = logging.getLogger(__name__)

TMP_PATH = "./tmp/init.lua"


def parse_nvim(template: str,
               dest: str,
               config: Dict,
               theme_name: str):

    logger.info("Loading nvim...")
    nvim_config: Dict = config.get('nvim', {})

    if 'default_path' in nvim_config:
        template: str = nvim_config['default_path']
    else:
        template = os.path.join(template, "init.lua")

    # write to tmp path
    with open(template, "r") as f_out, open(TMP_PATH, 'w') as f_in:
        for line in f_out.readlines():
            f_in.write(line)

    _configure_colorscheme(nvim_config)

    # clear out the old config
    _delete_in_folder(os.path.expanduser("~/.config/nvim/"))

    # write config
    with open(TMP_PATH, "r") as f_out, open(os.path.join(dest, "init.lua"), "w") as f_in:
        for line in f_out.readlines():
            f_in.write(line)

    return config


def _configure_colorscheme(nvim_config):

    colorscheme: str = nvim_config.get('colorscheme', 'gruvbox')
    cmd: str = f'vim.cmd[[colorscheme {colorscheme}]]'
    _overwrite_or_append_line(pattern='vim.cmd[[colorscheme',
                              replace_text=cmd)


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


def _delete_in_folder(path: str):
    logger.info(f"deleting files and folders in {path}")
    for filename in os.listdir(path):
        file_path = os.path.join(path, filename)
        try:
            if os.path.isfile(file_path) or os.path.islink(file_path):
                os.unlink(file_path)
                logger.info(f"deleted {file_path}")
            elif os.path.isdir(file_path):
                shutil.rmtree(file_path)
                logger.info(f"deleted {file_path}")
        except Exception as e:
            logger.critical('Failed to delete %s. Reason: %s' % (file_path, e))
