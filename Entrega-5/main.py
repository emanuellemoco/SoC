#!/usr/bin/python

import socket
import os
from flask import Flask, render_template, request, jsonify
import time

host = "/tmp/9Lq7BNBnBycd6nxy.socket"
sock = socket.socket(socket.AF_UNIX, socket.SOCK_STREAM)
x = sock.getsockopt( socket.SOL_SOCKET, socket.SO_KEEPALIVE)
sock.connect((host))

time.sleep(3)
while 1:
        sock.sendall(bytes('ola py!' + "\n", "utf-8"))
        time.sleep(3)
        received = str(sock.recv(1024), "utf-8")
        print(received)



app = Flask(__name__)

@app.route('/teste', methods = ['POST', 'GET'])
def status():
        status = request.form
        print("------------")
        sock.sendall(bytes('ola!' + "\n", "utf-8"))

        return "TESTEEEEEEE",200

if __name__ == '__main__':
   app.run(host='0.0.0.0', debug=True,port=80)



