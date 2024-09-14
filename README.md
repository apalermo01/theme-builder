# Dotfiles repo

This repo contains the default configuration for all my dotfiles, plus a series of python scripts that modify these configurations to be specific to a given theme.

The main configurations with everything that is consistent across themes (keybindings, vim plugins, etc.) is located in `./default_configs/`. 

Theme specific configs are located in `./themes/<theme_name>/<theme_name>.json`. `./themes/<theme_name>/` also contains any specific files that are meant to overwrite the default configs.


# Project plan for next iteration

The objective of this next phase of development is to drastically simplify the parsing process. Instead of restricting the entire theme to a single json file, I'm going to (wherever possible) define the persistent settings in default configs and set up files that append to these defaults. Any parsing that needs to be done to the default configs will be defined in a single json file for each theme. 

## Checklist of tools:

- [x] colors
    - [x] pywal
- [ ] wallpaper
    - [x] feh
    - [ ] hyprpaper
- [x] i3 
    - [x] initial pass
    - [x] configure terminal based on what's in config file
- [ ] hyprland 
- [x] polybar
- [ ] waybar
- [x] neovim
    - [x] default configs
    - [x] basic nvchad setup
    - [x] specify nvchad theme in config 
    - [x] specify separators (and other configurable things) in json files
        - going for a simpler option here and just overwriting chadrc
- [x] picom
- [x] kitty
    - [ ] set shell info based on theme's config
- [x] alacritty
- [ ] bash
- [x] fish
    - [x] initial pass
    - [x] configure prompt
        - this will be done in the appened snippet for each theme
- [ ] firefox
- [ ] zathura
- [x] rofi
- [ ] wofi
- [ ] tmux
 - [x] initial pass
 - [ ] auto-parse true color terminal settings based on what terminals are in theme file
- [ ] implement a more robust way of inserting configuration options into temp config files. For example, colorscheme for nvchad relies on an exact match of 'theme = "'
- [x] orgnaize allowed elements in utils
- [ ] documentation
    - [ ] add info about default path parameter
    - [ ] base configuration 
    - [ ] appended theme-specific config options

## theme structure
each theme has a set of folders, each corresponding to a tool / progam. there is a master json file specifying which tools are used.

## Wallpaper sources

Link to wallpaper for first hyprland rice: https://wallpaperaccess.com/download/cats-in-space-439064
- i3_minimal (v2): https://www.solidbackgrounds.com/black-solid-color-background.html
- i3_minimal: https://www.hongkiat.com/blog/beautiful-minimalist-desktop-wallpapers/
- hypr_synth1: https://www.uhdpaper.com/2024/05/moon-retrowave-4k-8k-8433a.html?m=0

# Configuration

## Format

Each theme is defined in the subfolder of the `themes` folder. The main configuration lives in a file called `theme.json`. The keys of this json file correspond to each tool / program that is modified in the specific theme. There is a QA utility that runs before any files are parsed to ensure that only one program of each type is in the config (for example, you can't have both i3wm and hyprland in the config).


## Global Options

**font_family**: for tools that have a main font family defined - specify that here

**default_path**: this is a parameter that is available in **all** tools. This overwrites the location of the default config file from `./default_configs/tool_name/...` to a file or directory of your choosing. This is useful if you want to completely rewrite the default for a given theme.

## Colors 

This is one of the required options. Pass this as the colors option in theme.json. It should look something like this:

```json
"colors": {
    "method": ...
}
```

The two supported methods are "manual" and "pywal"

**manual**
create a file called `colorsheme.json` in the theme's directory. Keys are color names and values are hex color codes. All other modules reference this file to get their colorscheme.

**pywal**
When you run `main.py --theme <theme name>`,  pywal will append its generated colors to `colorscheme.json` for consumption by other tools. This does not overwrite existing colors in `colorscheme.json` so you can still define your own colors.

## terminals

### Kitty

name in config: `kitty`

There are no options to pass in `theme.json`. However, if there are commands you wish to append to the default config file, put those in `theme_directory/kitty/`

## Window Managers

### i3

name in config: `i3wm`

## Bars

### Polybar

name in config: `polybar`

## Shells

### Bash 

name in config: `bash`

### Fish 

name in config: `fish`

## Neovim Distros

### Vanilla neovim 

name in config: `nvim`

### NvChad

name in config: `nvchad`

