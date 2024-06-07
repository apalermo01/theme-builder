from scripts.hypr import parse_hypr
import json

def main():
    theme_path = "./themes/hyprland_default/hyprland_default.json"
    template = "./default_configs/hyprland/hyprland.conf"
    
    with open(theme_path, "r") as f:
        config = json.load(f)

    parse_hypr(template=template,
               dest = "./testing_cfg.conf",
               config = config,
               theme_name = "hyprland_default.json"
               )

if __name__ == '__main__':
    main()
