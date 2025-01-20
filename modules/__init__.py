from . import colors
from . import i3
from . import wallpaper


modules = {
    'colors': colors.parse_colors,
    'i3': i3.parse_i3,
    'wallpaper': wallpaper.parse_wallpaper,
}
