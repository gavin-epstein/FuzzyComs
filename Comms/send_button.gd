extends Button

var messageEntry:TextEdit

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	messageEntry = $"../TextureRect/MessageEntry"




func encode(message:String)-> String:
	if globalNode.level =="0":
		return message
	else:
		return "Error Unknown Level"

func _on_pressed() -> void:
	var unencoded = messageEntry.text
	var encoded = encode(unencoded)
	var body = {}
	body['level'] = globalNode.level
	body['unencoded'] = unencoded;
	body['encoded'] = encoded;
	$MessageSender.sendMessage(globalNode.code, body);

func _http_request_completed(_result, response_code, headers, body):
	
	var json = JSON.new()
	json.parse(body.get_string_from_utf8())
	var response = json.get_data()
	if response == null:
		print(body.get_string_from_utf8())
		return
	if response["message"] == "Message Sent":
		messageEntry.text = ''
	elif response["message"] == "Level out of Sync":
		globalNode.level = response['level']
		_on_pressed() #try again
	elif response["message"] == "Failed to Send":
		pass
	
