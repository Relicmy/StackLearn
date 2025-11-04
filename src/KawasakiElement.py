from ElementGUI import MainMenu


class KawasakiMenu(MainMenu):
    
    def __init__(self) -> None:
        super().__init__()
        self.item = {}
    
    def add_chapter(self, chapter):
        if not chapter in self.item:
            self.item.setdefault(chapter, {}) 
    
    def add_button(self, name_button: str, chapter=None):
        if isinstance(chapter, str):
            if chapter in self.item:
                if not name_button in self.item[chapter]:
                    self.item[chapter][name_button] = ""
    
    def add_link_to_button(self, name_button: str, link:str, chapter=None):
        if isinstance(chapter, str):
            if chapter in self.item:
                if name_button in self.item[chapter]:
                    self.item[chapter][name_button] = link
    
    def get_list_button(self):
        return self.item

        
        
if __name__ == "__main__":
    
    pass