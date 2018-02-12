import socket, select, sys

sockClient = socket.socket(socket.AF_INET, socket.SOCK_STREAM)

try:
	sockClient.connect(('localhost', 8080))
except:
	print("Couldn't connect")
	sys.exit()

print("-- Joined Chat Server\r")
print("Type 'EXIT' to leave chat\r")
sys.stdout.write('> ')
sys.stdout.flush()

while True:
	messagesocket = [sys.stdin, sockClient]
	 
	# Getting readable sockets and reading them with select
	readsock, writesock, errsock = select.select(messagesocket, [], [])

	for sock in readsock:

		if sock is not sockClient:
			newMessage = sys.stdin.readline()
			sockClient.send(newMessage)
			sys.stdout.write('> ')
			sys.stdout.flush()
		else:
			newData = sock.recv(4096)
			if not newData:
				print("\rDisconnected from chat")
				sys.exit()
			else:
				sys.stdout.write(newData)
				sys.stdout.write('> ')
				sys.stdout.flush()