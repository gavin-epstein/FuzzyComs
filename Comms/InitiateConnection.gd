extends Node

var http_request

func _ready():
	# Create an HTTP request node and connect its completion signal.
	http_request = HTTPRequest.new()
	add_child(http_request)
	http_request.request_completed.connect(get_parent()._http_request_completed)

func setupConnection():
	# Perform a  request. The URL below returns JSON as of writing.
	var body = ""
	var error = http_request.request("https://gavinepstein.space/connection.php", [], HTTPClient.METHOD_POST, body)
	if error != OK:
		push_warning("An error occurred in the HTTP request.")
	return error
func joinExisting(code):
	var error = http_request.request("https://gavinepstein.space/connection.php?code="+code, [], HTTPClient.METHOD_GET)
	if error != OK:
		push_warning("An error occurred in the HTTP request.")
	return error
	
func sendMessage(code, body):
	body = JSON.stringify(body);
	var error = http_request.request("https://gavinepstein.space/message.php?code="+code, [], HTTPClient.METHOD_POST, body)
	if error != OK:
		push_warning("An error occurred in the HTTP request (message send).")
	return error
	
func getMessages():
	var code = globalNode.code
	if code == null:
		print("no code set")
		return
	var error = http_request.request("https://gavinepstein.space/message.php?code="+code, [], HTTPClient.METHOD_GET)
	if error != OK:
		push_warning("An error occurred in the HTTP request (message recieve).")
	return error

func updateLevel(level):
	var code = globalNode.code
	var body = {}
	body['level'] = level
	body = JSON.stringify(body);
	var error = http_request.request("https://gavinepstein.space/message.php?code="+code, [], HTTPClient.METHOD_PUT, body)
	globalNode.level = level
	#globalNode.levelChanged.emit()
	if error != OK:
		push_warning("An error occurred in the HTTP request (update Level).")
	return error

	


	
