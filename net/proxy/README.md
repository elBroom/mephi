#Прокси сервер

Проксирует данные из порта в защищенный порт

Запустить SSL сервер на порту 5443:

	ncat -l -p 5443 -m 10 --ssl --ssl-cert server.crt --ssl-key server.key -k

Запустить прокси:

	python proxy.py

Запустить клиент на порту 5000:

	ncat localhost 5000