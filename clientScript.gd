extends Node

# Configuration
var host = "127.0.0.1"  # Server IP (use "localhost" or actual IP)
var port = 6000
var peer: StreamPeerTCP = StreamPeerTCP.new()

func _ready():
	# Attempt to connect to the server
	var error = peer.connect_to_host(host, port)
	if error != OK:
		print("Error: Unable to connect to ", host, ":", port)
	else:
		print("Connecting to server...")

func _process(delta):
	# Poll the connection status
	peer.poll()  # Required to update the connection state
	
	if peer.is_connected_to_host():
		# Check for incoming data from server
		var available_bytes = peer.get_available_bytes()
		if available_bytes > 0:
			var data = peer.get_data(available_bytes)
			if data[0] == OK:
				var message = data[1].get_string_from_utf8()
				print("Received from server: ", message)
			else:
				print("Error receiving data")
		
		# Example: Send a message periodically or on input (e.g., after connecting)
		# For demo, send once after connecting (remove for production)
		if not has_sent_initial:  # Use a flag to send only once
			send_message("Hello from client!")
			has_sent_initial = true
	
	# Handle connection failure or disconnection
	elif peer.get_status() == StreamPeerTCP.STATUS_ERROR:
		print("Connection error")
	elif peer.get_status() == StreamPeerTCP.STATUS_NONE:
		print("Disconnected from server")

var has_sent_initial = false  # Flag for demo purposes

# Function to send a message to the server
func send_message(message: String):
	if peer.is_connected_to_host():
		var bytes = message.to_utf8_buffer()
		var error = peer.put_data(bytes)
		if error == OK:
			print("Sent to server: ", message)
		else:
			print("Error sending message")

func _exit_tree():
	# Clean up on exit
	peer.disconnect_from_host()
