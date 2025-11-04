"use strict"

class KnowledgeBase {
    constructor(data_kuka, data_kawa) {
        // add event
        this.buttonGroup = document.querySelector('.cmd-panel');
        
        this.btnNext = this.buttonGroup.querySelector('#next-cmd-button');
        this.btnDown = this.buttonGroup.querySelector('#back-cmd-button');

        this.btnNext.addEventListener('click', this.onNextClick.bind(this));
        this.btnDown.addEventListener('click', this.onDownClick.bind(this));

        this.currentIndex = 0
        this.system_var_kawa = data_kawa
        this.system_var_kuka = data_kuka
        this.system_var = null
        this.container = document.getElementById('group-container')
        this.path = window.location.pathname;
    }

    init(){
        if (this.path.includes("kuka")) {
            this.system_var = this.system_var_kuka;
            this.system_var_render()
        }
        if (this.path.includes("kawa")) {
            this.system_var = this.system_var_kawa;
            this.system_var_render()
        }
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
        const descriptionHtml = item.discriptions ? marked.parse(item.discriptions) : '';
        card.innerHTML = `
                        <div class="name-var">${this.escape(item['name-var'])}</div>
                        <div class="sintax">
                            <div class="tag">Синтаксис:</div>
                            <div class="text">${this.escape(item.sintax)}</div>
                        </div>
                        <div class="discriptions">
                            <div class="tag">Описание:</div>
                            <div class="text">${descriptionHtml}</div>
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


class HeaderText {
    constructor() {
        this.header = document.querySelector('.header-text');
        this.path = window.location.pathname;
    }

    paste_header_text() {
        if (!this.header) return;

        let text = '❓ Неизвестный раздел';

        if (this.path === '/' || this.path === '/index.html') {
            text = '📘 База знаний';
        }
        else if (this.path.startsWith('/docs')) {
            text = '📚 Документация';
        }
        else if (this.path.includes('kuka')) {
            text = '🤖 KUKA ROBOTICS';
        }
        else if (this.path.includes('kawa')) {
            text = '🤖 KAWASAKI ROBOTICS';
        }

        this.header.textContent = text;
    }
}


document.addEventListener('DOMContentLoaded', async () => {
    try {
        const [resKuka, resKawa] = await Promise.all([
            fetch('/static/json/sys_var_kuka.json'),
            fetch('/static/json/sys_var_kawasaki.json')
        ]);

        if (!resKuka.ok || !resKawa.ok) throw new Error('Ошибка загрузки JSON');

        const data_kuka = await resKuka.json();
        const data_kawa = await resKawa.json();

        const headerText = new HeaderText();
        headerText.paste_header_text();
        
        const kb = new KnowledgeBase(data_kuka, data_kawa);
        kb.init();
    } catch (err) {
        console.error('Инициализация провалена:', err);
    }
});