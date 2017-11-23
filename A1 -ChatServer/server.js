// Library imports
const net = require('net')			// stream-based TCP API
const colors = require('colors')	// console colours

var portnum = process.argv[2]		// get portnum from passed argument

var clientList = []					// client list

// Starting TCP server
net.createServer(function (socket) {
	socket.name = `${socket.remoteAddress}:${socket.remotePort}`
	clientList.push(socket)

	broadcast(`-- ${socket.name} joined chatroom\n`, socket)


	socket.on('end', function() {
		clientList.splice(clientList.indexOf(socket), 1)
		broadcast(`-- ${socket.name} left the chatroom\n`)
	});

	// Incoming messages from clients
	socket.on('data', function(data) {
		broadcast(`${socket.name}> ${data}`, socket)
	});

	function broadcast(message, sender) {
		clientList.forEach(function(client) {
			if (sender != client) client.write(message)
		});
		process.stdout.write(message)
	}

}).listen(portnum)

console.log(`Server running on port ${portnum}`.cyan + "\n")
