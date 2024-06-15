from typing import Dict, Union, List, Iterable, Tuple
import logging
import os
import shutil
from . fileutils import configure_other_files

TMP_PATH = "./tmp/hyprland.conf"
logger = logging.getLogger(__name__)

def parse_hypr(template: str,
               dest: str,
               config: Dict,
               theme_name: str):

    # allow config to overwrite default files
    if "default_path" in config['hypr']:
        template = config['hypr']['default_path']

    if 'other_files' in config['hypr']:
        configure_other_files(config['hypr']['other_files'])

    logger.info(f"pulling hyperland template from {template}")

    # copy teimplate into text files
    with open(template, "r") as f_in, open(TMP_PATH, "w") as f_out:
        for line in f_in.readlines():
            f_out.write(line)
    
    # all settings
    _write_colors(config)

    with open(TMP_PATH, "r") as f_in, open(dest, "w") as f_out:
       for r in f_in.readlines():
           f_out.write(r)

    logger.info(f"wrote to final directory: {dest}")

    return config

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

def _write_colors(config):
    
    hypr_colors = config['hypr']['colors']
    new_text = []
    config_text, new_text = _iterate_until_text(iter(_read_tmp()), new_text, "general {")

    for t in config_text:
        print(t)
        if "col" in t:
            key = t.split('.')[1].split(' ')[0]
            print("key = ", key)
            color1 = hypr_colors[key].get('color1')
            color2 = hypr_colors[key].get('color2')
            angle = hypr_colors[key].get('angle')
            new_str = f"    col.{key} = rbg({color1}) rbg({color2}) {angle}deg"
        elif '}' in t:
            break
        else:
            new_text.append(t)

    _write_tmp(new_text)


