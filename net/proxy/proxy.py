from _thread import start_new_thread
import socket
import ssl

def get_data(conn):
    resp = b''
    data = conn.recv(1024)
    conn.settimeout(0.1)
    while data:
        resp += data
        try:
            data = conn.recv(1024)
        except socket.error:
            break
    return data

def proxy_data(client, server):
    #Request
    data = get_data(client)
    server.send(data)

    #Response
    data = get_data(server)
    client.send(data)

    client.close()
    server.close()

def start(port_from=5000, port_to=5443):
    sock = socket.socket()
    sock.bind(('localhost', port_from))
    sock.listen(10)

    while True:
        conn, addr = sock.accept()
        serv = ssl.wrap_socket(socket.socket(), 'server.key', 'server.crt')
        serv.connect(('localhost', port_to))

        try:
            start_new_thread(proxy_data, (conn, serv))
        except KeyboardInterrupt:
            sock.close()
            break

if __name__ == "__main__":
    #Start server on 5443
    #ncat -l -p 5443 -m 10 --ssl --ssl-cert server.crt --ssl-key server.key -k
    #Start client on 5000
    #ncat localhost 5000
    start(5000, 5443)