from typing import Dict, List, Iterable, Tuple
import logging
import os
import json
import shutil

TMP_PATH = "./tmp/i3.config"
logger = logging.getLogger(__name__)


def parse_i3(template: str,
             dest: str,
             config: Dict,
             theme_name: str):

    logger.info("configuring i3...")
    # allow theme to overwrite template
    if "template" in config['i3wm']:
        template: str = config['i3wm']['default_path']
    else:
        template = os.path.join(template, "i3.config")

    # copy template into temp file
    with open(template, "r") as f_in, open(TMP_PATH, "w") as f_out:
        for line in f_in.readlines():
            f_out.write(line)

    # add terminal option
    _configure_terminal(config)

    # now write the other theme-specific settings
    theme_path = os.path.join(".", "themes", theme_name, "i3", "i3.config")
    with open(theme_path, "r") as f_in, open(TMP_PATH, "a") as f_out:
        for line in f_in.readlines():
            f_out.write(line)

    _configure_colors(theme_name)

    # now copy the config file to the destination directory
    dest_path = os.path.join(dest, "config")
    with open(TMP_PATH, "r") as tmp, open(dest_path, "w") as dest:
        for line in tmp.readlines():
            dest.write(line)
    logger.info(f"copied {TMP_PATH} to {dest_path}")
    return config


def _configure_terminal(config: Dict):

    terminal: str = config['i3wm'].get('terminal', 'gnome-terminal')
    pattern: str = "bindsym $mod+Return exec"
    replace_text: str = f"bindsym $mod+Return exec {terminal}"

    _overwrite_or_append_line(pattern=pattern,
                              replace_text=replace_text)

    logger.info(f"updated terminal: {terminal}")


def _configure_colors(theme_name: str):
    colorscheme_path: str =\
        os.path.join("themes", theme_name, "colors", "colorscheme.json")

    with open(colorscheme_path, "r") as f:
        colorscheme: Dict = json.load(f)

    text: List[str] = _read_tmp()

    new_text: List[str] = []

    for line in text:
        for color in colorscheme:
            line = line.replace(f"<{color}>", colorscheme[color])
        new_text.append(line)

    _write_tmp(new_text)


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
