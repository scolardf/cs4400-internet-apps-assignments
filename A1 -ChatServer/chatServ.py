import socket, select

# Dictionary - (client, roomNumber)
# while waiting to choose a room, roomNumber = 0
clientList = []
print("Client List made")

PORT = 8080

sockServer = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
print("SockServer initialized")

sockServer.bind(("localhost", PORT))
sockServer.listen(5)
print("SockServer listening")

# chatrooms = []
# chatrooms.append(Chatroom('Voyager'))
# chatrooms.append(Chatroom('Crescendolls'))


# # Chatroom Class, contains:
# # - Room name
# # - List of users in room
# class Chatroom:
# 	def __init__(self, name):
# 		self.name = name
# 		self.users = []

# 	def addUser(self, user):
# 		self.users.append(user)

# 	def removeUser(self, user):
# 		try:
# 			self.users.remove(user)
# 		except :
# 			print("ERROR: User " + user + " not found in Room " + self.name)

clientList.append(sockServer)
print("--Server running on Port " + str(PORT))

def broadcast(client, message):
	for s in clientList:
		if s is not client and s is not sockServer:
			try:
				s.send(message)
			except:
				s.close()
				clientList.remove(s)

while True:
	read, write, error = select.select(clientList, [], [])

	for sock in read:
		if sock is not sockServer:
			try:
				data = sock.recv(4096)

				if data:
					broadcast(sock, "\r" + str(sock.getpeername()) + "> " + data)

				if data.split("\n")[0] == "exit":
					broadcast(sock, "\r" + str(sock.getpeername()) + " left the room")
					print "Client " + str(addr) + " left"
					sock.close()
					clientList.remove(sock)
					continue
			except:
				continue
		else:
			newConn, newAddr = sockServer.accept()
			clientList.append(newConn)

			print "Client " + str(newAddr) + " joined"
			broadcast(newConn, "\r" + str(newAddr) + " joined the room")

sockServer.close()
