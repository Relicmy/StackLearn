


class MainMenu:

    def __init__(self) -> None:
        self.item = {}
        #self.DB = DB
        #self.load_item_DB()
    
    def connection_DB(self):
        pass
    
    def load_item_DB(self):
        pass
    
    def del_item_DB(self, name_button):
        pass
    
    def add_button(self, name_button: str, chapter=None):
        if name_button not in self.item:
            self.item[name_button] = ""
    
    def add_link_to_button(self, name_button: str, link:str, chapter=None):
        if name_button in self.item:
            self.item[name_button] = link
    
    def get_list_button(self):
        return self.item
    
    def del_button(self, name_button):
        if name_button in self.item:
            del self.item[name_button]
            return True
        return False
    

    
if __name__ == "__main__":
    MN = MainMenu()
    