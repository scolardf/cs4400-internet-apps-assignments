import http.server
import socketserver

PORT = 8080

reqHandle = http.server.SimpleHTTPRequestHandler
thisServ = socketserver.TCPServer(("", PORT), reqHandle)

print ("Serving at: PORT ", PORT)
thisServ.serve_forever()