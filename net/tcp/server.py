import socket

sock = socket.socket()
sock.bind(('localhost', 5000))
sock.listen(1)
conn, addr = sock.accept()

while(True):
    data = conn.recv(1024)
    if not data:
        break
    conn.send(data)
conn.close()
