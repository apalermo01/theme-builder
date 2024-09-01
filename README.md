# Dotfiles repo

This repo contains the default configuration for all my dotfiles, plus a series of python scripts that modify these configurations to be specific to a given theme.

The main configurations with everything that is consistent across themes (keybindings, vim plugins, etc.) is located in `./default_configs/`. 

Theme specific configs are located in `./themes/<theme_name>/<theme_name>.json`. `./themes/<theme_name>/` also contains any specific files that are meant to overwrite the default configs.


# Project plan for next iteration

The objective of this next phase of development is to drastically simplify the parsing process. Instead of restricting the entire theme to a single json file, I'm going to (wherever possible) define the persistent settings in default configs and set up files that append to these defaults. Any parsing that needs to be done to the default configs will be defined in a single json file for each theme. 

## Checklist of tools:

- [ ] colors
    - [ ] pywal
- [ ] wallpaper
    - [x] feh
    - [ ] hyprpaper
- [x] i3 
- [ ] hyprland 
- [x] polybar
- [ ] waybar
- [ ] neovim
    - [x] default configs
    - [x] basic nvchad setup
    - [ ] specify nvchad theme in config 
    - [ ] specify separators (and other configurable things) in json file
- [ ] picom
- [ ] kitty
- [ ] alacritty
- [ ] bash
- [ ] fish
- [ ] firefox
- [ ] zathura
- [x] rofi
- [ ] wofi
- [x] tmux

## theme structure
each theme has a set of folders, each corresponding to a tool / progam. there is a master json file specifying which tools are used.

## Wallpaper sources

Link to wallpaper for first hyprland rice: https://wallpaperaccess.com/download/cats-in-space-439064
- i3_minimal (v2): https://www.solidbackgrounds.com/black-solid-color-background.html
- i3_minimal: https://www.hongkiat.com/blog/beautiful-minimalist-desktop-wallpapers/
- hypr_synth1: https://www.uhdpaper.com/2024/05/moon-retrowave-4k-8k-8433a.html?m=0

# Wiki of available options (CURRENT)

## Colors 

This is one of the required options. Pass this as the colors option in theme.json. It should look something like this:

```json
"colors": {
    "method": ...
}
```

As of writing, the only supported option is "manual". In the colors folder of the theme, there should be a `colorscheme.json` file with key-value pairs for the color names. All other parsers in the theme will reference this file for color codes.


## Wiki of available options (OLD)

Each of the headings and sub-headings below represent an available key in the theme config. Keys that link to specific settings are shown as plain text, followed by a colon and a description of the available options

### alacritty

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
