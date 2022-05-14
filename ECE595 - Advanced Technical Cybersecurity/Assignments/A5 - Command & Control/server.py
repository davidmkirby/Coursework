from genericpath import exists
import time
import socket
import sys
import os

# Initialize s to socket
s = socket.socket()

# Initialize the host
host = socket.gethostname()

# Initialize the port
port = 8080

# Bind the socket with port and host
s.bind(('', port))

print("Waiting for connections...")

# listening for connections
s.listen()

# accepting the incoming connections
conn, addr = s.accept()

print(addr, "is connected to server.\n")

# take command as input
command = input(str("Enter Command: "))

conn.send(command.encode())

print("\nCommand has been sent successfully.")

# receive the confirmation
data = conn.recv(1024)

if data:
    if exists("info.txt"):
        file = open("info.txt", "r")
        print("\t>> Client info: ",file.read())
    else:
        print("\t>> File removed.")
else:
    print("\t>> No feedback from client.")
