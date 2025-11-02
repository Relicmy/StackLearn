.PROGRAM new_main ()

    ; === ГЛОБАЛЬНЫЕ КОНСТАНТЫ ===
    PORT = 9106 ; порт подключения
    MAX_LENGTH = 255 ; длина буфера для приема данных, защита от переполнения
    TIMEOUT_OPEN = 60 ; Без таймаутов программа может "зависнуть навсегда"
    TIMEOUT_RECV = 60 ; Без таймаутов программа может "зависнуть навсегда"
    TIMEOUT_SEND = 10 ; Без таймаутов программа может "зависнуть навсегда"
    SOCK_ID_UNKNOWN = -1 ; Чёткое обозначение "нет соединения"
    EC_OK = 1 ; Хранит дескриптор активного соединения с клиентом
    EC_FAIL = -1 ; ошибка подключения
    EC_TIMEOUT = -2 ; ошибка времени подключения
    EC_NODATA = -3 ; ошибка данных нету

    ; === ГЛОБАЛЬНЫЕ ПЕРЕМЕННЫЕ ===
    sock_id = SOCK_ID_UNKNOWN ; сокет пока что ничего не имеет
    curr_ec = EC_FAIL ; Позволяет процедурам возвращать статус через глобальную переменную

open_socket:
    ; Сбросим статус
    curr_ec = EC_FAIL

        ; --- Шаг 2.1: Закрыть все активные сокеты (очистка) ---
        ; TSP_STATUS - локальная переменная для количества активных сокетов, .port для списка портов, .socket для перечня сокетов и 3 переменные для ошибок!
        ; .$ips[0] Массив IP-адресов подключённых клиентов (строки)
    TCP_STATUS .num_sockets, .ports[0], .sockets[0], .errs[0], .suberrs[0], .$ips[0] 
    IF .num_sockets > 0 THEN ; если у нас есть активные подключения то перебрать их и закрыть!
        FOR .i = 0 TO .num_sockets - 1 ; почему .num_socket -1 нихрена не понятно ведь AS язык роботов кавасаки id начинается с 0
            IF .sockets[.i] <> 0 THEN ; тут вообще не ясно <> что больше меньше нуля? это что типо == 0?
                TCP_CLOSE .status, .sockets[.i] ; TCP_CLOSE  - закрывает соединение если оно есть и возвращает что? staus - возврат статуса закрытия socket[.i] мы передаем id socketa
                ; (можно добавить PRINT для отладки)
            END
        END
    END

        ; --- Шаг 2.2: Слушать порт ---
        ; TCP_LISTEN - переменная в которую записывается успешно ли наше подключение к порту, port - глобальная переменная которую мы ранее задали с нашим портом!
    TCP_LISTEN .ret, PORT 
    IF .ret < 0 THEN ; если .ret вернет все что меньше 0 то это значит ошибка подключения к порту
        PRINT 0: "ERROR: TCP_LISTEN failed, code =", .ret
        GOTO open_socket_exit ; просто выход из процедуры open_socket с ошибкой. На данном этапе мы еще не подключились к порту сервера
    END

        ; --- Принять подключение (ЭТОГО НЕ БЫЛО В ТВОЁМ КОДЕ!) ---
    TCP_ACCEPT sock_id, PORT, TIMEOUT_OPEN, .$client_ip[1]
    IF sock_id < 0 THEN
        PRINT 0: "ERROR: TCP_ACCEPT failed or timeout"
        TCP_END_LISTEN .ret, PORT
        GOTO open_socket_exit
    END

    PRINT 0: "INFO: Client connected, sock_id =", sock_id
    curr_ec = EC_OK

    
open_socket_exit:

  ; ВАЖНО: чтобы не "провалиться" в recv, нужно уйти в main
  ; Но как? — просто поставим метку-заглушку и НИЧЕГО не делаем.
  ; Главное — не начинать recv сразу после!

    ; === ПРОЦЕДУРА: получить данные от клиента ===
recv:
  ; Сбросим статус
  curr_ec = EC_FAIL

  ; Переменная для количества полученных байт
  .num_bytes = 0

  ; Буфер для входящих данных (массив строк, но используем как буфер)
  ; В AS: TCP_RECV записывает данные в .$recv_buf[0] как строку
  ; TCP_RECV - системная функция, .ret - возвращает ошибку -1 -2 -3 если есть
  ; sock_id система запишет сюда id нашего сокета
  ; .$recv_buf[0] - локальная переменная которая получит данные что были переданы, [0] - тут мы задаем только точку входа а TCP_RECV сам все сделает?
  ; .num_bytes - в данную переменную запишется количество переданных данных в байтах
  ; TIMEOUT_RECV Устанавливаем максимальное время ожидание  для получения данных
  ; MAX_LENGTH - мы говорим тут какая максимальная длина будет у .$recv_buf[0]
  TCP_RECV .ret, sock_id, .$recv_buf[0], .num_bytes, TIMEOUT_RECV, MAX_LENGTH

  ; Анализируем результат
  IF .ret < 0 THEN ; если ошибки есть то принтуем что за 0? затем свое понимание ошибки и ошибку которая вернулась
    ; Ошибка или таймаут
    PRINT 0: "RECV: timeout or error, code =", .ret
    curr_ec = EC_TIMEOUT ; статус получения данных присваеваем числу с нашей ошибкой
  ELSE
    ; .ret >= 0 → операция завершена 
    IF .num_bytes > 0 THEN ; проверяем что данные вообще есть
      ; Есть данные!
      .$message = .$recv_buf[0]   ; сохраняем в локальную строку (можно передать дальше)
      PRINT 0: "RECV: received", .num_bytes, "bytes:", .$message ; если данные есть то мы в 0левой канал отправляем данные которые получени
      curr_ec = EC_OK ; статус что успешно получены данные
    ELSE
      ; .num_bytes == 0 → клиент закрыл соединение
      PRINT 0: "RECV: client disconnected (0 bytes)" ; если данных нет то мы в 0левой канал отправляем данные которые получени
      curr_ec = EC_NODATA ; статус проверки есть ли данные ставим на нашу соответствующую переменную
    END
  END


  ; === ПРОЦЕДУРА: отправить строку клиенту ===
; Вход: .$data — строка, которую нужно отправить
send:
  ; Сбросим статус
  curr_ec = EC_FAIL

  ; Подготовим буфер: копируем входную строку в буфер отправки
  .$send_buf[0] = .$data

  ; Количество элементов для отправки (в AS — это количество "блоков", обычно 1)
  .buf_count = 1

  ; TCP_SEND -  Отправляем данные, .ret это локальная переменная для ошибок, sock_id это socket[sock_id] .send_buf[0] для отправки данных .$data
  ; .buf_count, TIMEOUT_SEND - количество элементов (обычно 1) , время максимального ожидания чтобы небыло вечного ожидания отправки
  TCP_SEND .ret, sock_id, .$send_buf[0], .buf_count, TIMEOUT_SEND

  ; Проверяем результат
  IF .ret < 0 THEN
    PRINT 0: "SEND: failed, error code =", .ret
    curr_ec = EC_FAIL
  ELSE
    PRINT 0: "SEND: OK, sent", .ret, "bytes"
    curr_ec = EC_OK
  END

  ; === ШАГ 5: ОСНОВНОЙ ЦИКЛ ПРОГРАММЫ ===
main:
  ; Подключиться к клиенту
  CALL open_socket
  IF curr_ec <> EC_OK THEN
    PRINT 0: "MAIN: Failed to open socket, retrying..."
    TWAIT 2
    GOTO main
  END

  ; Основной цикл обработки
main_loop:
  CALL recv
  IF curr_ec == EC_TIMEOUT THEN
    ; Таймаут — просто ждём дальше
    GOTO main_loop
  END

  IF curr_ec == EC_NODATA THEN
    ; Клиент отключился — закрываем сокет и перезапускаем сервер
    TCP_CLOSE .status, sock_id
    sock_id = SOCK_ID_UNKNOWN
    PRINT 0: "MAIN: Client disconnected, restarting server..."
    GOTO main
  END

  IF curr_ec == EC_OK THEN
    ; === ОБРАБОТКА СООБЩЕНИЯ ===
    PRINT 0: "MAIN: Processing message:", .$message

    ; Пример: просто ответить "OK"
    .$data = "OK"
    CALL send

    ; Можно добавить логику разбора:
    ; .$cmd = $DECODE(.$message, ",", 0)
    ; .msg_type = VAL(.$cmd)
    ; IF .msg_type == 20 THEN ... END
  END

  GOTO main_loop