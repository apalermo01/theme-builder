import json
import logging
import os
import shutil
import yaml
from typing import Dict, Iterable, List, Tuple

from jinja2 import Template

from .validate_modules import allowed_elements, validate_polybar

logger = logging.getLogger(__name__)


def module_wrapper(tool):
    def func_runner(module):
        def inner(
            config: Dict, theme_path: str, template_dir: str, destination_dir: str, orient: str, **kwargs
        ):

            # default files
            with open("./configs/paths.yaml", "r") as f:
                path_configs = yaml.safe_load(f)

            logger.debug(f"template dir = {template_dir}")
            logger.debug(f"destination dir = {destination_dir}")
            if "template_path" in config[tool]:
                template_dir = config[tool]["template_path"]
                if template_dir[-1] != "/":
                    template_dir = template_dir + "/"

            copy_files_from_template(template_dir, destination_dir)

            # files to append
            if "append" in config[tool]:
                copy_files_from_filelist(
                    config[tool]["append"], theme_path, tool, overwrite=False
                )

            if "overwrite" in config[tool]:
                copy_files_from_filelist(
                    config[tool]["overwrite"], theme_path, tool, overwrite=True
                )

            return module(
                config=config,
                theme_path=theme_path,
                template_dir=template_dir,
                destination_dir=destination_dir,
                **kwargs,
            )
        return inner

    return func_runner


def copy_files_from_filelist(
    file_list: List[Dict[str, str]], theme_path: str, tool_name: str, overwrite: bool
):
    """
    Copy folder structure into dotfiles.

    file_list is a list of dictionaries with the structure:
    [
        {"from": <theme file to copy from>,
         "to": <theme file to copy to>
         }
    ]

    if the "to" file already exists, then "from" gets appended to "to"

    theme_name and tool_name are used to configure the base paths:
    "from": ./themes/<theme_name>/<tool_name>/<from path>
    "to": ./themes/<theme_name>/dots/<to path>
    """

    for file_info in file_list:
        if '~' in file_info['from']:
            from_path: str = os.path.expanduser(file_info["from"])
        elif file_info['from'].startswith('./'):
            from_path: str = file_info["from"]
        else:
            from_path: str = os.path.join(
                os.getcwd(), theme_path, tool_name, file_info["from"]
            )

        to_path: str = os.path.join(os.getcwd(), theme_path, "build", file_info["to"])

        basepath: str = "/".join(to_path.split("/")[:-1])
        if not os.path.exists(basepath):
            os.makedirs(basepath)

        if os.path.isfile(to_path) and not overwrite:
            logger.info(f"appending {from_path} to {to_path}")
            if '~' in from_path:
                from_path = os.path.expanduser(from_path)
            with open(from_path, "r") as f_from, open(to_path, "a") as f_to:
                for line in f_from.readlines():
                    f_to.write(line)
        else:
            logger.debug(f"copying {from_path} to {to_path}")
            shutil.copy2(from_path, to_path)


def configure_destination(dest: str, *subfolders: List[str]) -> str:
    dest = os.path.join(dest, *subfolders[:-1])
    if not os.path.exists(dest):
        logger.debug(f"creating path {dest}")
        os.makedirs(dest)
    return os.path.join(dest, *subfolders)


def validate_config(config: Dict, theme_path: str) -> Tuple[bool, Dict]:
    for key in allowed_elements:

        num_elements_of_category = sum(
            1 for i in allowed_elements[key] if i in config.keys()
        )
        if num_elements_of_category > 1:
            print(
                f"Multiple elements found for {key}. Config must have one or none of {allowed_elements[key]}"
            )

            return False, {}

    if "polybar" in config:
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


def copy_files_from_template(src_folder: str, dest_folder: str):

    if not os.path.exists(dest_folder):
        logger.debug(f"making dest subfolder: {dest_folder}")
        os.makedirs(dest_folder)

    for root, dirs, files in os.walk(src_folder):

        subfolder = root.replace(src_folder, "")
        folder = os.path.join(dest_folder, subfolder)

        if not os.path.exists(folder):
            os.makedirs(folder)
        logger.debug(f"files = {files}")
        for file in files:
            src_file = os.path.join(root, file)
            dest_file = os.path.join(dest_folder, subfolder, file)

            logger.debug(f"copied {src_file} to {dest_file}")
            shutil.copy2(src_file, dest_file)


def overwrite_or_append_line(pattern: str, replace_text: str, dest: str):
    config_text = read_file(dest)
    new_text = []

    config_text, new_text = iterate_until_text(
        iter(config_text), new_text, pattern, append_target=False
    )
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


def iterate_until_text(
    text: Iterable[str],
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


def append_if_not_present(text: str, dest: str):

    config_text = read_file(dest)

    text_found = False
    for line in config_text:
        if text in line:
            text_found = True

    if not text_found:
        config_text.append(text)
        write_file(config_text, dest)


def configure_colors(theme_path: str):

    colorscheme_path = os.path.join("./", theme_path, "colors", "colorscheme.json")

    if not os.path.exists(colorscheme_path):
        return

    with open(colorscheme_path, "r") as f:
        colorscheme = json.load(f)

    build_path = os.path.join(theme_path, "build")

    for root, dirs, files in os.walk(build_path):
        subfolder = root.replace(build_path, "")

        # subfolder[1:] ensures that it's not mistakenly taken for
        # an absolute path
        folder = os.path.join(build_path, subfolder[1:])

        for file in files:
            if "json" in file \
                or "jsonc" in file \
                or ".zsh" in file:
                continue

            full_path = os.path.join(folder, file)

            with open(full_path, "r") as f:
                template_content = f.read()

            template = Template(template_content)
            rendered = template.render(colorscheme)
            
            with open(full_path, "w") as f:
                f.write(rendered)
