import socket
import select

# Dictionary - (client, roomNumber)
# while waiting to choose a room, roomNumber = 0
clientList = []
print("Client List made")

PORT = 8080
print("Port Num Made")

sockServer = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
print("SockServer initialized")

sockServer.bind(("localhost", PORT))
print("SockServer bound")
sockServer.listen()
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
print("- Server running on Port " + str(PORT))

def broadcast(client, message):
	for sock in clientList:
		if sock is not client and sock is not sockServer:
			try:
				sock.send(message)
			except:
				sock.close()
				clientList.remove(sock)

while True:
	read, write, error = select.select(clientList, [], [])

	for sock in read:
		if sock is sockServer:
			newConn, newAddress = sockServer.accept()
			clientList.append(newConn)

			print("-- New Client: " + str(newConn))
			broadcast(newConn, str(newAddress) + " entered the room \n")

		else:
			try:
				newData = sock.recv(4096)

				if newData:
					broadcast(sock, "\n" + str(sock.getPeerName()) + "- " + newData)

				if newData.split("\n")[0] == "EXIT":
					broadcast(sock, "\n" + str(sock.getPeerName()) + " left the room")
					print("-- Client: " + str(sock) + " left room")
					sock.close()
					clientList.remove(sock)
					continue

			except:
				continue
