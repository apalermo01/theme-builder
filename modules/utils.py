import logging
import os

logger = logging.getLogger(__name__)


def default_parser(default_config_path: str,
                   destination_config_path: str,
                   theme_config_path: str,
                   theme_name: str,):

    logger.info(f"{theme_name} is running the default parser")

    write_source_to_file(default_config_path, destination_config_path)

    if os.path.exists(theme_config_path):
        append_source_to_file(theme_config_path, destination_config_path)


def write_source_to_file(src: str, dst: str):

    with open(src, "r") as f_src, open(dst, "w") as f_dst:
        for line in f_src.readlines():
            f_dst.write(line)

    logger.info(f"wrote {src} to {dst}")


def append_source_to_file(src: str, dst: str):

    with open(src, "r") as f_src, open(dst, "a") as f_dst:
        for line in f_src.readlines():
            f_dst.write(line)

    logger.info(f"appended {src} to {dst}")


def append_text(src: str, text: str):

    with open(src, "a") as f:
        f.write(text)
