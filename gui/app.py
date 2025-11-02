from flask import Flask, render_template, request, redirect, url_for


app = Flask(__name__)

@app.route('/')
def main_menu():
    return render_template('main_menu.html')

@app.route('/kuka/')
def kuka():
    return render_template("kuka/kuka.html")

@app.route('/kuka/system-var/')
def system_var():
    return render_template('kuka/system_var.html')

if __name__ == "__main__":
    # Запуск сервера
    app.run(host='0.0.0.0', port=5000, debug=True, use_reloader=False)
    