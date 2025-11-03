extends Node

# Configuration
var port = 6000  # Choose a port > 1024
var server = TCPServer.new() 
var peer: StreamPeerTCP = null  # Will hold the connected client

func _ready():
	# Start listening on the specified port
	var error = server.listen(port, "*")  # "*" binds to all interfaces
	if error != OK:
		print("Error: Unable to start server on port ", port)
	else:
		print("Server listening on port ", port)

func _process(delta):
	# Check for incoming connections if not already connected
	if peer == null and server.is_connection_available():
		peer = server.take_connection()
		if peer != null:
			print("Client connected from: ", peer.get_connected_host(), ":", peer.get_connected_port())
	
	# If connected, check for incoming data
	if peer != null and peer.is_connected_to_host():
		# Check if data is available
		var available_bytes = peer.get_available_bytes()
		if available_bytes > 0:
			var data = peer.get_data(available_bytes)
			if data[0] == OK:  # data[0] is error code, data[1] is byte array
				var message = data[1].get_string_from_utf8()  # Convert bytes to string
				print("Received from client: ", message)
				# Optionally respond
				send_message("Hello from server!")
			else:
				print("Error receiving data")
	
	# Handle disconnection
	elif peer != null:
		print("Client disconnected")
		peer = null

# Function to send a message to the connected peer
func send_message(message: String):
	if peer != null and peer.is_connected_to_host():
		var bytes = message.to_utf8_buffer()  # Convert string to bytes
		var error = peer.put_data(bytes)
		if error == OK:
			print("Sent to client: ", message)
		else:
			print("Error sending message")

func _exit_tree():
	# Clean up on exit
	if peer != null:
		peer.disconnect_from_host()
	server.stop()
