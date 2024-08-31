from typing import Dict, Union, List, Iterable, Tuple
import logging
import os
import shutil

TMP_PATH = "./tmp/i3.config"
logger = logging.getLogger(__name__)

def parse_i3(template: str,
             dest: str,
             config: Dict,
             theme_name: str):

    # do backup (not implemented here)
    # if backup:
    #     i3_path = os.path.expanduser("~/.config/i3/")
    #     fname= f"i3_config_backup_{get_timestamp()}"
    #     shutil.copy2(src=os.path.join(i3_path, "config"),
    #                  dst=os.path.join(i3_path, fname))
    with open(TMP_PATH, "w") as f:
        logger.warning("overwrote i3.config temp file")
    
    # allow config to overwrite default files
    if "default_path" in config['i3wm']:
        template = config['i3wm']['default_path']

    # copy template into text files
    with open(template, "r") as f_in, open(TMP_PATH, "a") as f_out:
        for line in f_in.readlines():
            f_out.write(line)

    # all settings
    _write_colors(config)
    _configure_terminal(config)
    _configure_bindsyms(config)
    _configure_extra_lines(config)
    _configure_extend(config, theme_name)

    # move to final location
    with open(TMP_PATH, "r") as f_out, open(dest, "w") as f_in:
        for r in f_out.readlines():
            f_in.write(r)
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

def _write_colors(config: Dict):
   
    def _generate_color_str(key: str,
                            colors: str,
                            theme_config: Dict) -> str:

        newline = f"client.{key}"

        # color entry may be a string or a list
        if isinstance(colors, str):
            colors = colors.split(' ')

        for color_name in colors:
            
            # hex code
            if '#' in color_name:
                newline += f"\t{color_name}"

            # look up from pallet
            else:
                print("pallet = ", pallet)
                print("color name = ", color_name)
                newline += f"\t{theme_config['colors']['pallet'][color_name]}"

        return newline

    logger.info("writing colors")
    pallet = config['colors']['pallet']
    i3_colors = config['i3wm']['colors']
    new_text = []
    config_text, new_text = _iterate_until_text(iter(_read_tmp()), new_text, "# Theme colors")
    logger.info("got config text")

    for t in config_text:

        if 'client' in t:
            key = t.split(' ')[0].split('.')[1]
            colors = i3_colors[key] 
            new_text.append(_generate_color_str(key, colors, config) + "\n")

        else:
            new_text.append(t)

    _write_tmp(new_text)

def _configure_terminal(config: Dict):
    terminal = config['i3wm'].get('terminal', 'gnome-terminal')

    _overwrite_or_append_line(pattern="bindsym $mod+Return exec",
                              replace_text=f"bindsym $mod+Return exec {terminal}")
    logger.info(f"updated terminal: {terminal}")

def _configure_bindsyms(config: Dict):
    """Handle theme-specific bindsyms"""

    if 'bindsyms' in config['i3wm']:
        for command in config['i3wm']['bindsyms']:
            cmd = f"bindsym {command} {config['i3wm']['bindsyms'][command]}"
            _overwrite_or_append_line(
                    pattern=f"bindsym {command}",
                    replace_text=cmd
                    )
            logger.info(f"added command {cmd}")

def _configure_extra_lines(config: Dict):
    """Write any extra lines specified in the config file to i3"""

    if config['i3wm'].get('extra_lines'):
        with open("./tmp/i3.config", "a") as f:
            for line in config['i3wm']['extra_lines']:
                f.write(f"{line}\n")
                logger.info(f"added extra line: {line}")

def _configure_extend(config: Dict, theme_name: str):
    
    extend_path = os.path.join('.', 'themes', theme_name, 'i3wm.extend')
    if os.path.exists(extend_path):
        config_text = _read_tmp()
        with open(extend_path) as f:
            for line in f.readlines():
                config_text.append(line)

        _write_tmp(config_text)
        logger.info("appended i3wm.extend")
    
    


