# Dotfiles repo

This repo contains the default configuration for all my dotfiles, plus a series
of python scripts that modify these configurations to be specific to a given
theme.

The main configurations with everything that is consistent across themes
(keybindings, vim plugins, etc.) is located in `./default_configs/`. 

Theme specific configs are located in
`./themes/<theme_name>/<theme_name>.json`. `./themes/<theme_name>/` also
contains any specific files that are meant to overwrite the default configs.


## theme structure
each theme has a set of folders, each corresponding to a tool / progam. there is a master json file specifying which tools are used.

## Wallpaper sources

- 000 - 
- hyprcats https://wallpaperaccess.com/download/cats-in-space-439064
- i3_minimal (v2): https://www.solidbackgrounds.com/black-solid-color-background.html
- i3_minimal: https://www.hongkiat.com/blog/beautiful-minimalist-desktop-wallpapers/
- hypr_synth1: https://www.uhdpaper.com/2024/05/moon-retrowave-4k-8k-8433a.html?m=0

# Disclaimer

This project is primarily for personal use and I take no responsibility for
what happens to your system if you use this. Make sure you back up critical
files before running this. 

# Installation instructions

## Dependencies
- any modern version of python should be sufficient. Required python packages
are toml and matplotlib.

## Instructions
- clone this repo
- make sure python is installed
- install matplotlib and toml using your method of choice (requirements.txt is provided)


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

When supplying color information to config files, the syntax is `<colorname>` where `colorname` is a key in `colorscheme.json`. For example, this may be a line in a configuration file for i3:

```
client.focused	         <color1>	  <foreground>	 <color8>   	<color1>	    <color1>
```

If `colorscheme.json` contains:
```json
{
    "foreground": "#dceabf",
    "color1": "#427655",
    "color8": "#9aa385"
}
```

Then this line will resolve to:
```
client.focused	         #427655	  #dceabf	 #9aa385   	#427655	    #427655
```

## terminals

### Kitty

name in config: `kitty`

There are no options to pass in `theme.json`. However, if there are commands
you wish to append to the default config file, put those in
`theme_directory/kitty/kitty.conf`.

When preparing the final config file, this sets the default shell using `chsh`
(right now this only works for fish) and updates the "font_family" option to
match "font" in the theme's config (if it exists).

### alacritty

## Window Managers

### i3

name in config: `i3wm`

There are no options to pass in `theme.json`. However, you must create a
`theme_directory/i3/i3.config` file to manage colors at a minimum. You're free
to put other settings and bindings in there specific to the theme as well.

#### Coordination with other modules 

##### picom

If picom is also in the theme's config, then the following lines are automatically appended to the i3 config:

```
exec killall picom
exec_always picom --config ~/.config/picom.conf
```
## Bars

### Polybar

name in config: `polybar`

There is no default polybar theme, you must create a
`theme_directory/polybar/polybar.ini` file to manage the polybar theme.

## Compositors

### picom 

name in config: `picom`

Create a `theme_directory/picom/picom.conf` file to overwrite default settings.

## Shells

### Bash 

name in config: `bash`

The only supported setting in `theme.json` is "feats". This is a list of
additions to bashrc. These are the allowed feats:

- `cowsay_fortune`: pipes fortune into a random cow from cowsay 
- `neofetch`: runs neofetch 
- `run_pywal`: runs pywal on the passed wallapper path. This will automatically
change the terminal colors to match the theme.
- `git_onefetch`: prints info about a git repo when you cd into it.

example:

```json
{
    'bash': {
        'feats': ['neofetch', 'cowsay_fortune']
    }
}
```

### Fish 

name in config: `fish`

The only supported setting in `theme.json` is "feats". This is a list of
additions to bashrc. These are the allowed feats:

- `cowsay_fortune`: pipes fortune into a random cow from cowsay 
- `neofetch`: runs neofetch 
- `run_pywal`: runs pywal on the passed wallapper path. This will automatically change the terminal colors to match the theme.
- `git_onefetch`: prints info about a git repo when you cd into it.

example:

```json
{
    'fish': {
        'feats': ['neofetch', 'cowsay_fortune']
    }
}
```
## Neovim Distros

### Vanilla neovim 

name in config: `nvim`

### NvChad

name in config: `nvchad`

`colorscheme`: the name of the colorscheme to use. To find the list of
available options, hit `,th` while nvchad is open.

**Important note**: the theme change in nvchad only works when you select the
theme using `,th` (default for changing theme) or save lua/chadrc.lua in nvim.
Whenver you switch the theme, open `~/.config/nvim/lua/chadrc.lua` and hit `:w`
to re-save the file and have the new theme take effect.

`overwrite`: this is a list of files in `theme_directory/theme_name/nvchad`
that will be loaded in place of the default version of the file.

In this example, the default chadrc is overwritten by
`theme_directory/theme_name/nvchad/lua/chadrc.lua`. The will probably be a
common pattern, since the options for configuring the UI (e.g. changes to
tabufile, statusline, etc.) live in chadrc.lua (see
[here](#https://nvchad.com/docs/config/nvchad_ui) for documentation)

```json
"nvchad": {
    "overwrite": ["lua/chadrc.lua"]
},
```

## Other tools

### tmux

name in config: `tmux` 

If you want to replace or append to the default config, create a
`theme_directory/tmux/tmux.conf` file.

If this file is meant to **replace** the default config, then pass 
`default_path` as an option in `theme.json`. Here's an example:

```json
{
    tmux: {
        'default_path': './themes/theme_name/tmux/tmux.conf'
    }
}
```

If this file is meant to **append** to the default config, then don't pass
anything in `theme.json`

After all files are processed, the parser always writes the tpm run command to the bottom of the config, so there's no need to put that in your custom config. Here's the exact command:

`run ~/.tmux/plugins/tpm/tpm`

### rofi

name in config: `rofi`

No custom settings in `theme.json` are available, but if you want to **append**
any settings to the default config, then create the
`theme_directory/rofi/config.rasi` file. If you want to **replace** the default
config, then create the `them_directory/rofi/config.rasi` file and also pass the path to that file as the `default path` parameter. Here's an example:

```json
{
    rofi: {
        'default_path': './themes/theme_name/rofi/config.rasi'
    }
}
```

# Roadmap

Aside from constant documentation updates, here is a list of programs that I
plan to add to the parser:

- [ ] backup functionality
- [ ] dry-run functionality
- [ ] installation scripts
- [ ] hyprpaper
- [ ] hyprland
- [ ] waybar 
- [ ] other neovim distros (e.g. LunarVim)
- [ ] firefox
- [ ] zathura
- [ ] wofi
- [ ] neofetch (for custom prompts)
- [ ] fastfetch (for custom prompts)

- [ ] investigate nix (I've never used nix before, but it would be interesting
to see if I can port this over).

# Credits

Big thanks to Stavros Grigoriou (stav121) for providing the initial inspriation
for this project: https://github.com/stav121/i3wm-themer.

