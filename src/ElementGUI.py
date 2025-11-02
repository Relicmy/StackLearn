


class MainMenu:

    def __init__(self, DB) -> None:
        self.item = {}
        self.DB = DB
        self.load_item_DB()
    
    def connection_DB(self):
        pass
    
    def load_item_DB(self):
        pass
    
    def del_item_DB(self, name_button):
        pass
    
    def add_button(self, name_button: str) -> bool:
        if name_button in self.item:
            return False
        self.item[name_button] = ""
        return True
    
    def add_link_to_button(self, name_button: str, link:str):
        if not name_button in self.item:
            return False
        self.item[name_button] = link
        return True
    
    def del_button(self, name_button):
        if name_button in self.item:
            del self.item[name_button]
            return True
        return False
    

    
if __name__ == "__main__":
    MN = MainMenu("ass")
    