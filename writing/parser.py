import json
import yaml
from pathlib import Path


def parse_yaml(file_path):
    
    with open(Path(file_path), encoding="utf-8") as f:
        data = yaml.safe_load(f)
        return data

def all_parse(folder_path):
    all_list = []
    folder_path = Path(folder_path)
    if folder_path.is_dir():
        for file in folder_path.iterdir():
            if file.is_file():
                group = file.stem
                # Open file
                with open(file, encoding="utf-8") as f:
                    data = yaml.safe_load(f)
                    # Create dict to list is file
                    dir_card = {}
                    
                    # iteration data is file
                    for i in data:
                        #if name file not in dict
                        if not group in dir_card:
                            dir_card[f"{group}"] = []
                        dir_card[f"{group}"].append(i)
                    
                    # if iteration file complite, add dict file data in all_list
                    all_list.append(dir_card)
    # if iter dir complite all_list to json.dump
    with open("gui/static/json/sys_var.json", 'w', encoding="utf-8") as file:
        json.dump(all_list, file, ensure_ascii=False, indent=2)
    

                    
            
# if __name__ == "__main__":
#     meta = all_parse("kuka")
    


