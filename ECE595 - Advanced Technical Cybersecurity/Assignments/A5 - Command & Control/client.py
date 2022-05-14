import time
import socket
import sys
import os

# Initialize s to socket
s = socket.socket()

# Initialize the host
host = "127.0.0.1"

# Initialize the port
port = 8080

# bind the socket with port and host
s.connect((host, port))

print("Connected to server.")

# receive the command from master program
command = s.recv(1024)
command = command.decode()

# match the command and execute it on slave system
if command == "attack":
	print("Command is :", command)
	os.system('uname -a >info.txt')
	s.send("Command received".encode())

if command == "delete":
	print("Command is :", command)
	os.system('rm info.txt')
	s.send("Command received".encode())