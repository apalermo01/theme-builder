from . import colors
from . import i3
from . import wallpaper
from . import bash

modules = {
    "colors": colors.parse_colors,
    "i3": i3.parse_i3,
    "wallpaper": wallpaper.parse_wallpaper,
    "bash": bash.parse_bash
}
