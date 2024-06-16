# Dotfiles repo

This repo contains the default configuration for all my dotfiles, plus a series of python scripts that modify these configurations to be specific to a given theme.

The main configurations with everything that is consistent across themes (keybindings, vim plugins, etc.) is located in `./default_configs/`. 

Theme specific configs are located in `./themes/<theme_name>/<theme_name>.json`. `./themes/<theme_name>/` also contains any specific files that are meant to overwrite the default configs.




# Wallpaper sources

Link to wallpaper for first hyprland rice: https://wallpaperaccess.com/download/cats-in-space-439064

- i3_minimal: https://www.hongkiat.com/blog/beautiful-minimalist-desktop-wallpapers/


# Wiki of available options

Each of the headings and sub-headings below represent an available key in the theme config. Keys that link to specific settings are shown as plain text, followed by a colon and a description of the available options

## alacritty

- `default_path` - copies the alacritty config from this path into the normal config directory for the app

There isn't any configuration to do in the theme's json file. If you want a custom alacritty config, save it in the theme's folder and link to it in default path.

Examples:

using global default config:

```json
{
    "alacritty": {}
}
```

using an overwritten config specific to the theme

```json
{
    "alacritty": {
        "default_path": "./themes/my_theme_name/alacritty.toml"
        }
}
```
## bash

## colors

### settings
- `color_mode`: "pywal" or "manual"
    - if "pywal" is selected, then pywal will be used to generate a colorscheme based on the wallpaper path. If manual, then the user will be expected to populate the "pallet" component of the colors entry.

### pallet
- <color_name>: hex code for colors
    - this takes a series of keys representing the hex code of colors for the given template

## fish

## hypr

## i3

## mako

## nvim

## picom

## tmux

## vim

## wallpapers

## waybar

## wofi

