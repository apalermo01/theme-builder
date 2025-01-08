import logging
import os
from typing import Dict, List, Iterable, Tuple
from . import allowed_elements
import shutil
from .validate_modules import validate_polybar

logger = logging.getLogger(__name__)


def module_wrapper(tool):
    def func_runner(module):
        def inner(config: Dict,
                  theme_path: str,
                  template_dir: str,
                  destination_dir: str):

            # default files
            if 'template_dir' in config[tool]:
                template_dir = config[tool]['template_dir']
                if template_dir[-1] != '/':
                    template_dir = template_dir + '/'

            copy_all_files(template_dir, destination_dir)

            # files to append
            if 'copy' in config[tool]:
                copy_files_from_filelist(config[tool]['copy'],
                                         theme_path,
                                             tool)
            return module(config=config,
                          theme_path=theme_path,
                          template_dir=template_dir,
                          destination_dir=destination_dir)

        return inner
    return func_runner


def copy_files_from_filelist(file_list: List[Dict[str, str]],
                             theme_path: str,
                             tool_name: str):
    """
    Copy folder structure into dotfiles.

    file_list is a list of dictionaries with the structure:
    [
        {"from": <theme file to copy from>,
         "to": <theme file to copy to>,
         "overwrite": <optional: overwrites the default file>}
    ]

    if the "to" file already exists, then "from" gets appended to "to"

    theme_name and tool_name are used to configure the base paths:
    "from": ./themes/<theme_name>/<tool_name>/<from path>
    "to": ./themes/<theme_name>/dots/<to path>
    """

    for file_info in file_list:
        from_path = os.path.join(
            os.getcwd(), theme_path, tool_name, file_info["from"])
        to_path = os.path.join(os.getcwd(), theme_path, "dots", file_info["to"])

        if not os.path.exists('/'.join(to_path.split('/')[:-1])):
            os.makedirs('/'.join(to_path.split('/')[:-1]))
        
        logger.info("file info = ")
        logger.info(file_info)
        if os.path.isfile(to_path) and not file_info.get('overwrite', False):
            logger.info(f"appending {from_path} to {to_path}")
            with open(from_path, "r") as f_from, \
                    open(to_path, "a") as f_to:
                for line in f_from.readlines():
                    f_to.write(line)
        else:
            logger.info(f"copying {from_path} to {to_path}")
            shutil.copy2(from_path, to_path)


def configure_destination(dest: str, *subfolders: List):
    dest = os.path.join(dest, *subfolders[:-1])
    if not os.path.exists(dest):
        logger.info(f"creating path {dest}")
        os.makedirs(dest)
    return os.path.join(dest, *subfolders)


def validate_config(config: Dict, theme_path: str) -> bool:
    for key in allowed_elements:

        num_elements_of_category = sum(
            1 for i in allowed_elements[key] if i in config.keys())
        if num_elements_of_category > 1:
            print(f"\x1b[31mMultiple elements found for {
                  key}. Config must have one or none of {allowed_elements[key]}")

            return False, {}

    if 'polybar' in config:
        return validate_polybar(config, theme_path)
    return True, config


def write_source_to_file(src: str, dst: str):

    with open(src, "r") as f_src, open(dst, "w") as f_dst:
        for line in f_src.readlines():
            f_dst.write(line)

    logger.info(f"wrote {src} to {dst}")


def append_source_to_file(src: str, dst: str):

    if not os.path.exists(src):
        return

    with open(src, "r") as f_src, open(dst, "a") as f_dst:
        for line in f_src.readlines():
            f_dst.write(line)

    logger.info(f"appended {src} to {dst}")


def append_text(src: str, text: str):

    with open(src, "a") as f:
        f.write(text)


def copy_all_files(src_folder: str, dest_folder: str):

    logger.info(f"os is walking {src_folder}")
    if not os.path.exists(dest_folder):
        logger.info(f"making dest subfolder: {dest_folder}")
        os.makedirs(dest_folder)

    for root, dirs, files in os.walk(src_folder):
        logger.info("=============")
        logger.info(f"root = {root}")
        logger.info(f"dirs = {dirs}")
        logger.info(f"files = {files}")
        logger.info(f"dest folder = {dest_folder}")

        subfolder = root.replace(src_folder, "")
        folder = os.path.join(dest_folder, subfolder)
        logger.info(f"folder = {folder}")

        if not os.path.exists(folder):
            os.makedirs(folder)
            logger.info(f"created a new folder: {folder}")

        for file in files:
            src_file = os.path.join(root, file)
            dest_file = os.path.join(dest_folder, subfolder, file)

            logger.info(f"copied {src_file} to {dest_file}")
            shutil.copy2(src_file, dest_file)
    


def overwrite_or_append_line(
        pattern: str,
        replace_text: str,
        dest: str
):
    config_text = read_file(dest)
    new_text = []

    config_text, new_text = iterate_until_text(iter(config_text),
                                               new_text,
                                               pattern,
                                               append_target=False)
    new_text.append(f"{replace_text}\n")
    for t in config_text:
        new_text.append(t)

    write_file(new_text, dest)


def read_file(tmp_path: str) -> List:
    with open(tmp_path, "r") as f:
        lines = f.readlines()
    return lines


def write_file(text: List[str], tmp_path: str):
    with open(tmp_path, "w") as f:
        f.writelines(text)


def iterate_until_text(text: Iterable[str],
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


def append_if_not_present(
        text: str,
        dest: str
):

    config_text = read_file(dest)

    text_found = False
    for line in config_text:
        if text in line:
            text_found = True

    if not text_found:
        config_text.append(text)
        write_file(config_text, dest)
