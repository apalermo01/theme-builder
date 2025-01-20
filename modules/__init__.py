from . import colors, i3, wallpaper

modules = {
    "colors": colors.parse_colors,
    "i3": i3.parse_i3,
    "wallpaper": wallpaper.parse_wallpaper,
}
