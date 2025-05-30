from . import colors
from . import i3
from . import wallpaper
from . import bash
from . import fish
from . import zsh
from . import hyprland
from . import polybar 
from . import waybar 
from . import nvim 
from . import tmux 
from . import rofi 
from . import picom 
from . import kitty 
from . import alacritty
from . import fastfetch
from . import apps
from . import okular
from . import global_settings
from . import yazi

modules = {
    "colors": colors.parse_colors,
    "i3": i3.parse_i3,
    "wallpaper": wallpaper.parse_wallpaper,
    "bash": bash.parse_bash,
    "fish": fish.parse_fish,
    "hyprland": hyprland.parse_hyprland,
    "polybar": polybar.parse_polybar,
    "waybar": waybar.parse_waybar,
    "nvim": nvim.parse_nvim,
    "tmux": tmux.parse_tmux,
    "rofi": rofi.parse_rofi,
    "picom": picom.parse_picom,
    "kitty": kitty.parse_kitty,
    "alacritty": alacritty.parse_alacritty,
    "fastfetch": fastfetch.parse_fastfetch,
    "apps": apps.parse_apps,
    "zsh": zsh.parse_zsh,
    "okular": okular.parse_okular,
    "global": global_settings.parse_global,
    "yazi": yazi.parse_yazi,

}
