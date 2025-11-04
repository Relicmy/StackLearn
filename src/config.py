import sys
import os

# Добавляем текущую директорию src в путь Python
current_dir = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, current_dir)

from ElementGUI import MainMenu
from KukaElement import KukaMenu
from KawasakiElement import KawasakiMenu


""""""""""""""""""""""""""""""""""""""""""
""""""""""""""" MAIN MENU """""""""""""""""
""""""""""""""""""""""""""""""""""""""""""
if True:
    dc_button_main = {"Python": "", "Kuka": "kuka", "Kawasaki": "kawasaki", "Сис. Админ.": "",
                   "Базовая инженерия": "", "Алгебра": "", "Физика": "",
                   "Доп. навыки": ""}
    MM = MainMenu()
    for key, val in dc_button_main.items():
        MM.add_button(key)
        MM.add_link_to_button(key, val)


""""""""""""""""""""""""""""""""""""""""""
""""""""""""""" KUKA MENU """""""""""""""""
""""""""""""""""""""""""""""""""""""""""""
if True:
    dc_button_kuka = {"programming": {
                    "System var": "system_var", "KRL": "", "EthernetKRL": "", "Блочное програм-ние": "",
                    "Экосистема": ""},
                 
                    "soft": {
                        "Work visual": "", "Visual component": "", "Office lite": "", "Orange": "",
                        "VS code": ""
                    },
                    
                    "integration" : {
                        "Устройство": "", "Безопасность": "", "Направления": "", "Документация": "",
                        "Доп. навыки": ""
                    }}
    
    KM = KukaMenu()
    for chapter in dc_button_kuka:
        for key, val in dc_button_kuka[chapter].items():
            KM.add_chapter(chapter)
            KM.add_button(key, chapter=chapter)
            KM.add_link_to_button(key, val, chapter=chapter)



""""""""""""""""""""""""""""""""""""""""""
""""""""""""""" KAWASAKI MENU """""""""""""""""
""""""""""""""""""""""""""""""""""""""""""
if True:
    dc_button_kawasaki = {"programming": {
                        "System var": "", "AS": "", "Блочное програм-ние": "",
                        "Controller SDK/API": ""},
                    
                        "soft": {
                            "K-ROSET": "", "KIDE": "", "VS code": ""
                        },
                        
                        "integration" : {
                            "Устройство": "", "Безопасность": "", "Направления": "", "Документация": "",
                            "Доп. навыки": ""
                        }}
    
    KWM = KawasakiMenu()
    for chapter in dc_button_kawasaki:
        for key, val in dc_button_kawasaki[chapter].items():
            KWM.add_chapter(chapter)
            KWM.add_button(key, chapter=chapter)
            KWM.add_link_to_button(key, val, chapter=chapter)
    print(KWM.get_list_button())