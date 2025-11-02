.PROGRAM main.pc ()
  ; *******************************************************************
  ;
  ; Program:      main.pc
  ; Comment:      
  ; Author:       User
  ;
  ; Date:         9/29/2025
  ;
  ; *******************************************************************
  ;
  port = 9106
  max_lenght = 255
  tout_open = 60
  tout_rec = 60
  tout_send = 60
  SOCK_ID_UNKNOWN = -1;
  ;
  ;GLOBAL ERROR CODE CONSTS
  CALL_EC_OK = 1;
  CALL_EC_FAIL = -1;
  CALL_EC_TIMEOUT = -2;
  CALL_EC_NODATA = -3;
  CALL_EC_MOVE_NIR = -4;

  sock_id = -1             ; ID главного сокета (сервер)
  client_id = -1           ; ID клиентского сокета
      ; Строковые переменные для обмена данными
  .$received_data = ""     ; сюда приходят данные от клиента
  .$response_data = ""     ; сюда пишем ответ для клиента
  .$temp = ""              ; временная строка для обработки


  curr_call_ec = CALL_EC_FAIL;

  PRINT 0: "OPEN_SOCET: Checking for active sockets and closing them"
  TCP_STATUS .number,.ports[0],.sockets[0],.errors[0],.suberrors[0],.$ips[0]
  IF .number>0 THEN
      FOR .i = 0 TO .number-1
      IF .sockets[.i]<>0 THEN
          PRINT 0: "OPEN_SOCET: Closing socket with id: ",.sockets[.i]
          TCP_CLOSE .status,.sockets[.i]
      END
      END
  END
  .er_count = 0

  ;
listen:
  TCP_LISTEN .ret,port
  IF .ret<0 THEN
    IF .er_count>=5 THEN
      PRINT 0: "OPEN_SOCET: CAN,T LISTEN 5 TIMES"
      sock_id = SOCK_ID_UNKNOWN
      GOTO exit
    ELSE
      .er_count = .er_count+1
      PRINT 0: "OPEN_SOCET: ERROR WHILE LISTEN: ",.ret
      GOTO listen
    END
  ELSE
    PRINT 0: "OPEN_SOCET: TCP LISTEN OK",.ret,port
  END
  .er_count = 0
;
accept:
  TCP_ACCEPT sock_id,port,tout_open,ip[1]
  IF sock_id<0 THEN
    IF .er_count>=9999 THEN
      PRINT 0: "OPEN_SOCET: no active clients, exit"
      TCP_END_LISTEN ret,port
      sock_id = SOCK_ID_UNKNOWN
    ELSE
      .er_count = .er_count+1
      PRINT 0: "OPEN_SOCET: waiting for connection ..."
      GOTO accept
    END
  ELSE
    PRINT 0: "OPEN_SOCET: TCP ACCEPT OK"
    curr_call_ec = CALL_EC_OK
  END
; 
  .$send_buf[0] = .$data
  .buf_n = 1
  TCP_SEND .sret,sock_id,.$send_buf[0],.buf_n,tout_send
  IF .sret<0 THEN
    PRINT 0: "SEND: ERROR",.sret
  ELSE
    ;PRINT "SEND: OK",.sret
  END
exit:
;

.END
