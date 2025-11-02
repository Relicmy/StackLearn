"use strict"

class KnowledgeBase {
    constructor(data) {
        // add event
        this.buttonGroup = document.querySelector('.right-button-group');
        
        this.btnNext = this.buttonGroup.querySelector('#next-button');
        this.btnDown = this.buttonGroup.querySelector('#down-button');

        this.btnNext.addEventListener('click', this.onNextClick.bind(this));
        this.btnDown.addEventListener('click', this.onDownClick.bind(this));

        this.currentIndex = 0
        this.system_var = data
        this.container = document.getElementById('group-container')
    }

    onDownClick() {
        if (this.currentIndex != 0) {
            this.currentIndex--;
            this.system_var_render();
        }
    }

    onNextClick() {
        this.currentIndex++;
        this.system_var_render();
    }

    init(){
        this.system_var_render()
    }

    system_var_render(){
        const group = this.system_var[this.currentIndex];
        this.container.innerHTML = ''
        const group_name = Object.keys(group)[0];
        

        const groupDiv = document.createElement('div');
        groupDiv.className = 'group-card';

        const title = document.createElement('h1');
        title.textContent = group_name;
        groupDiv.appendChild(title);

        group[group_name].forEach(element => {
            let card = this.create_card(element)
            groupDiv.appendChild(card)
        });
        this.container.appendChild(groupDiv)
        this.updateCounter();
        
    }

    create_card(item){
        const card = document.createElement('div');
        card.className = "card"
        card.innerHTML = `
                        <div class="name-var">${this.escape(item['name-var'])}</div>
                        <div class="sintax">
                            <div class="tag">Синтаксис:</div>
                            <div class="text">${this.escape(item.sintax)}</div>
                        </div>
                        <div class="discriptions">
                            <div class="tag">Описание:</div>
                            <div class="text">${this.escape(item.discriptions)}</div>
                        </div>
                        <div class="example">
                            <div class="tag">Пример:</div>
                            <div class="text"><pre>${this.escape(item.example)}</pre></div>
                        </div>
                        `
        return card
    };

    escape(text) {
        if (typeof text !== 'string') return text || '';
        return text
            .replace(/&/g, '&amp;')
            .replace(/</g, '<')
            .replace(/>/g, '>')
            .replace(/"/g, '&quot;')
            .replace(/'/g, '&#039;');
    }
    
}



document.addEventListener('DOMContentLoaded', async () => {
    try {
        const response = await fetch('/static/json/sys_var.json');
        if (!response.ok) throw new Error('Ошибка загрузки');
        const data = await response.json();

        const kb = new KnowledgeBase(data);
        kb.init();
    } catch (err) {
        console.error('Инициализация провалена:', err);
    }
});