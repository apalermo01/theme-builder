import logging
from typing import List, Iterable, Tuple, Dict
import os
import shutil
logger = logging.getLogger(__name__)

TMP_PATH = "./tmp/nvchad/"

nvchad_files = [
    "init.lua",
    "lua/chadrc.lua",
    "lua/mappings.lua",
    "lua/options.lua",
    "lua/plugins/init.lua",
    "lua/configs/conform.lua",
    "lua/configs/lazy.lua",
    "lua/configs/lspconfig.lua"
]


def _copy_file(src, dest):
    with open(src, "r") as f_out, open(dest, 'w') as f_in:
        for line in f_out.readlines():
            f_in.write(line)


def parse_nvchad(template: str,
                 dest: str,
                 config: Dict,
                 theme_name: str):

    logger.info("Loading NvChad...")

    nvim_config: Dict = config.get('nvim', {})
    overwrite_files: List = nvim_config.get('overwrite', [])
    append_files: List = nvim_config.get('append', [])

    logger.info(f"files to overwrite: {overwrite_files}")
    logger.info(f"files to append: {append_files}")

    # write to tmp path
    lua_tmp_path = os.path.join(TMP_PATH, "lua")
    lua_plugins_tmp_path = os.path.join(TMP_PATH, "lua", "plugins")
    lua_configs_tmp_path = os.path.join(TMP_PATH, "lua", "configs")

    for path in [TMP_PATH, lua_tmp_path, lua_plugins_tmp_path, lua_configs_tmp_path]:
        if not os.path.exists(path):
            os.mkdir(path)

    # write to tmp
    for f in nvchad_files:
        if f in overwrite_files:
            _copy_file(os.path.join("themes", theme_name, "nvchad", f),
                       os.path.join(TMP_PATH, f))
        else:
            _copy_file(os.path.join(template, f),
                       os.path.join(TMP_PATH, f))

    # append files as needed
    for f in append_files:
        src = os.path.join("themes", theme_name, "nvchad", f)
        dst = os.path.join(TMP_PATH, f)
        with open(src, "r") as f_src, open(dst, "a") as f_dst:
            for line in f_src.readlines():
                f_dst.write(line)

    # configure theme
    _configure_colorscheme(nvim_config)

    # clear out the old config
    _delete_in_folder(os.path.expanduser("~/.config/nvim/"))

    # write to final folder
    lua_dest_path = os.path.join(dest, "lua")
    lua_plugins_dest_path = os.path.join(dest, "lua", "plugins")
    lua_configs_dest_path = os.path.join(dest, "lua", "configs")

    for path in [dest, lua_dest_path, lua_plugins_dest_path, lua_configs_dest_path]:
        if not os.path.exists(path):
            os.mkdir(path)

    for f in nvchad_files:
        src = os.path.join(TMP_PATH, f)
        dst = os.path.join(dest, f)
        _copy_file(src, dst)
        logger.info(f"wrote {src} to {dst}")

    logger.info("done setting up NvChad")

    return config


def _configure_colorscheme(nvim_config):
    colorscheme = nvim_config.get('colorscheme', 'gruvchad')
    pattern: str = 'theme = "'
    text: str = f'  theme = "{colorscheme}",'
    path: str = "./tmp/nvchad/lua/chadrc.lua"
    _overwrite_or_append_line(path=path,
                              pattern=pattern,
                              replace_text=text
                              )
    # colorscheme: str = nvim_config.get('colorscheme', 'gruvbox')
    # cmd: str = f'vim.cmd[[colorscheme {colorscheme}]]'
    # _overwrite_or_append_line(pattern='vim.cmd[[colorscheme',
    #                           replace_text=cmd)


def _read_tmp(path: str) -> List:
    with open(path, "r") as f:
        lines = f.readlines()
    return lines


def _write_tmp(text: List[str], path: str):
    with open(path, "w") as f:
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
        path: str,
        pattern: str,
        replace_text: str,
):
    config_text = _read_tmp(path)
    new_text = []

    config_text, new_text = _iterate_until_text(iter(config_text),
                                                new_text,
                                                pattern,
                                                append_target=False)
    new_text.append(f"{replace_text}\n")

    for t in config_text:
        new_text.append(t)

    _write_tmp(new_text, path)


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
