import socket

host = 'localhost'
port = 23

# Создание TCP-сокета
sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
sock.connect((host, port))

# Отправка AS-команд
sock.send(b'EXECUTE pg1\n')

# Получение ответа
response = sock.recv(1024)
print(response.decode())

sock.close()