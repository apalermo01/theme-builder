# Theme Builder 

This is a theme / rice builder for linux systems. It's a way to quickly switch
your dotfiles between different desktop environments / themes. 

Each program or tool has a base configuration defined in `default_configs`. Each
theme is configured in the themes folder by a `themes.json` file along with
configuration files that append or overwrite the default configurations. This
way, you define what you want to be common among all themes in `default_configs`
and define the theme-specific differences in the theme-specific folder.

When the theme is built, a `dots` folder is created in the theme's folder. This
folder has the same structure as your home directory with the configuration for
each program in the correct place. You can then load the configuration from the
dots folder by using the internal overwrite tool that creates a backup in
`~/.config/` and overwrite all existing configs, or use another method of your
choice such a symlinks, gnu stow, or another automation tool.

# Disclaimer

This project is primarily for personal use and I take no responsibility for
what happens to your system if you use this. Make sure you back up critical
files before running this. 

# Quickstart

## Installation 
Any modern version of python should suffice. To set up the project, simply clone
the repo, set up a virtual environment, and install matplotlib and toml.

```bash 
git clone git@github.com:apalermo01/theme-builder.git
cd theme-builder 
python -m venv env 
source ./env/bin/activate 
pip install -r requirements.txt
```

## Changing Themes

To switch between themes, run this: 
```bash 
python main.py --theme theme_name --no-test
```

This will build the theme in the `./themes/theme_name/` folder. For example, to
build hyprcats:

```bash
python main.py --theme hyprcats --no-test
```

If you want to overwrite your existing configuration files, then pass the
`--migration-method` argument:

```bash
python main.py --theme hyprcats --no-test --migration-method overwrite
```

This will create a backup folder inside `~/.config/dotfiles_backups` with the
current timestamp and overwrite the configs for each of the programs you specify
in `theme.json` with the configs inside `./themes/theme_name/dots/`.


# Configuration 

## Format 

The best way to investigate the available options are by inspecting the test
themes inside the `./tests` folder.


Each of the folders inside `./themes/` represents a specific theme / rice. The
options for each theme are specific inside the `theme.json` file, where the key
is the program name and the theme-specific settings are in the nested json.

Any files that are appended / copied are in the `./themes/theme_name/rule_name`
folder. For example, custom options for i3 configuration for the trees theme
live in `./themes/theme_name/trees/i3/config`. 

# Credits

Big thanks to Stavros Grigoriou (stav121) for providing the initial inspriation
for this project: https://github.com/stav121/i3wm-themer.

