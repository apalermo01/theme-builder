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
    _write_colors_and_general_settings(config)
    #_write_animations(config)

    # write final config to dest
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

def _write_colors_and_general_settings(config):
    #print("WRITING COLORS") 
    hypr_colors = config['hypr']['colors']
    new_text = []
    config_text, new_text = _iterate_until_text(iter(_read_tmp()), new_text, "general {")

    for t in config_text:
        if "col" in t:
            key = t.split('.')[1].split(' ')[0]
            color1 = hypr_colors[key].get('color1')
            color2 = hypr_colors[key].get('color2', color1)
            angle = hypr_colors[key].get('angle', 0)
            new_str = f"\tcol.{key} = rgb({color1}) rgb({color2}) {angle}deg\n"
            new_text.append(new_str)
        elif '}' in t:
            new_text.append('}')
            break
        else:
            t = _look_for_key_in_config(t, config['hypr'])
            new_text.append(t)
    
    # write the rest of the file
    for t in config_text:
        new_text.append(t)

    _write_tmp(new_text)


def _look_for_key_in_config(line, hypr_config):

    key = line.split('=')[0].strip()
    if hypr_config.get(key):
        line = key + ' = ' + hypr_config.get(key)
    return line

def _write_animations(config):
    
    def _get_default_bezier_cfgs():
        config_text, new_text = _iterate_until_text(iter(_read_tmp()), [], "animations {")
        cfg = {}
        for t in config_text:
            if 'bezier' in t.split('=')[0]:
                key = t.split('=')[1].split(',')[0].strip()
                cfg[key] = {
                        'x0': float(t.split('=')[1].split(',')[1].strip()),
                        'y0': float(t.split('=')[1].split(',')[2].strip()),
                        'x1': float(t.split('=')[1].split(',')[3].strip()),
                        'y1': float(t.split('=')[1].split(',')[4].strip()),
                        }
        return cfg
    
    def _write_bezier(bezier_cfg, key):
        line = '\t'
        line += 'bezier = '
        line += key 
        for k in ['x0', 'y0', 'x1', 'y1']:
            line += ', ' + str(bezier_cfg[k])
        line += '\n'
        return line

    def _get_default_animation_cfgs():
        config_text, new_text = _iterate_until_text(iter(_read_tmp()), [], "animations {")
        cfg = {}
        for t in config_text:
            
            if (len(t.split('=')) > 1) and ('animation' in t.split('=')[0]):
                key = t.split('=')[1].split(',')[0].strip()
                # name, on/off, speed, curve, style
                cfg[key] = {
                    'on': t.split('=')[1].split(',')[1].strip(),
                    'speed': t.split('=')[1].split(',')[2].strip(),
                    'curve': t.split('=')[1].split(',')[3].strip()
                    }
                if len(t.split('=')[1].split(',')) > 4:
                    cfg[key]['style'] = t.split('=')[1].split(',')[4].strip()
        return cfg
    
    def _write_animation(animation_cfg, key):
        line = '\t'
        line += 'animation = '
        line += key
        for k in ['on', 'speed', 'curve']:
            line += ', ' + animation_cfg[k]
        if 'style' in animation_cfg:
            line += ', ' + animation_cfg['style']
        line += '\n'
        return line

    
    # pull the config
    if config['hypr'].get('animations') == None:
        animation_config = {'enabled': 'yes',
                            'animation': {},
                            'bezier': {}}
    else:
        animation_config = config['hypr']['animations']


    new_text = []

    # parse the existing configs from the template file and combine those 
    # with what's in the theme file
    default_beziers = _get_default_bezier_cfgs()
    new_beziers = animation_config['bezier']

    default_animations = _get_default_animation_cfgs()
    new_animations = animation_config['animation']

    config_text, new_text = _iterate_until_text(iter(_read_tmp()), new_text, "animations {")
   
    beziers_to_write = {}
    animations_to_write = {}

    for k in default_beziers:
        if k in new_beziers:
            beziers_to_write[k] = new_beziers[k]
        else:
            beziers_to_write[k] = default_beziers[k]

    for k in new_beziers:
        # use this check to make sure we're not double adding beziers
        if k not in default_beziers:
            beziers_to_write[k] = new_beziers[k]

    
    for k in default_animations:
        if k in new_animations:
            animations_to_write[k] = new_animations[k]
        else:
            animations_to_write[k] = default_animations[k]

    for k in new_animations:
        if k not in default_animations:
            animations_to_write[k] = new_animations[k]
    
    # write everything to the output file
    new_text.append(f'\tenabled = {animation_config["enabled"]}\n')

    for b in beziers_to_write:
        new_text.append(_write_bezier(beziers_to_write[b], b))

    new_text.append('\n')

    for a in animations_to_write:
        new_text.append(_write_animation(animations_to_write[a], a))

    for t in config_text:
        if '}' in t:
            new_text.append('}\n')
            break

    for t in config_text:
        new_text.append(t)

    
    _write_tmp(new_text)
