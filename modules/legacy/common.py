import shutil

def configure_other_files(files_cfg):
    for key in files_cfg.keys():
        src = files_cfg[key]['src']
        dest = files_cfg[key]['dest']

        shutil.copy(src=src, dst=dest)

