import socket

sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
sock.bind(('localhost', 5000))

while(True):
    data, addr = sock.recvfrom(1024)
    if not data:
        break
    sock.sendto(data, addr)
sock.close()
