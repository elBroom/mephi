import socket

sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
addr = ('localhost', 5000)

print("Connect to localhost:5000")
while(True):
    data = input('c > ')
    if not data:
        break
    sock.sendto(data.encode("utf8"), addr)
    data, serv = sock.recvfrom(1024)
    print("s > {}".format(data.decode("utf8")))

sock.close()
print("Connection close")
