import yaml
import os
import shutil 
import json

def parse_scripts(
    config: dict, root_path: str
):
    print("configuring scripts...")
    default_scripts = set()
    with open("./default_configs/scripts/paths.yaml", "r") as f:    
        f_read = yaml.safe_load(f) 
        for e in f_read['scripts']:
            default_scripts.add(json.dumps(e))
    if 'scripts' in config and config['scripts'] is not None and len(config['scripts']) > 0:
        for entry in config['scripts']:
            print("custom entry = ", entry)
            default_scripts.add(json.dumps(entry))
    
    default_scripts_dict = []
    for e in default_scripts:
        default_scripts_dict.append(json.loads(e))
    
    for entry in default_scripts_dict:
        src_path = entry['from']
        to_path = entry['to']
        to_folder = '/'.join(to_path.split('/')[:-1])
        full_path = os.path.join(root_path, to_path)

        if not os.path.exists(os.path.join(root_path, to_folder)):
            os.makedirs(os.path.join(root_path, to_folder))
            print("created ", os.path.join(root_path, to_folder))
        
        shutil.copy2(src_path, full_path)
        print(f"copied {src_path} to {full_path}")

        


