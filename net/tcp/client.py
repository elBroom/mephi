import socket

sock = socket.socket()
sock.connect(('localhost', 5000))

print("Connect to localhost:5000")
while(True):
    data = input('c > ')
    if not data:
        break
    sock.send(data.encode("utf8"))
    data = sock.recv(1024)
    print("s > {}".format(data.decode("utf8")))

sock.close()
print("Connection close")
