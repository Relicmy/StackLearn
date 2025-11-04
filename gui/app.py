from flask import Flask, render_template, request, redirect, url_for
import sys
import os

sys.path.append(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

from src.config import KM, MM, KWM


app = Flask(__name__)
app.secret_key = 'hopel'

@app.route('/')
def main_menu():
    obj_button = MM.get_list_button()
    return render_template('main_menu.html', obj_button=obj_button)

@app.route('/kuka/')
def kuka():
    obj_button = KM.get_list_button()
    return render_template("kuka/kuka.html", obj_button=obj_button)

@app.route('/kuka/system-var/')
def system_var():
    return render_template('kuka/system_var.html')

@app.route('/kawasaki/')
def kawasaki():
    obj_button = KWM.get_list_button()
    return render_template('kawasaki/kawasaki.html', obj_button=obj_button)

if __name__ == "__main__":
    # Запуск сервера
    app.run(host='0.0.0.0', port=5000, debug=True, use_reloader=False)
    