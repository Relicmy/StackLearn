from ElementGUI import MainMenu
import json


class KukaMenu(MainMenu):
    
    def __init__(self, DB) -> None:
        super().__init__(DB)


class SystemVar(MainMenu):
    
    def __init__(self, DB) -> None:
        super().__init__(DB)
        
    def create_card(self, link_file_py):
        file = {"group-card": f"{link_file_py["group-card"]}", "card": {}}
        card = {"name-var": "",
                "sintax": "",   
                "discriptions": "",
                "example": "" 
                }
        
        for cd in link_file_py["card"]:
            pass
        
        
if __name__ == "__main__":
    
    pass
            
        
        
    