extends Button

var messageEntry:TextEdit
var display
var colors = ["red","orange","white", "black", "green","yellow", "blue","purple", "pink", "brown", "grey", "gray","color","colours"]
var shapes = ["circle", "triangle", "square", "cross", "pentagon","diamond", "rectangle", "rhombus", "quadrilateral", "oval", "ellipse", "star","shape"]
var numbers = ["number","1","2","3","4","5","6","7","8","9","0","one","two","three","four","five","six","seven","eight","nine","ten","eleven","twelve","thirteen", "fourteen","fifteen","sixteen","seventeen", "eighteen", "nineteen", "twenty", "thirty","fourty", "forty","fifty", "sixty","seventy","eighty","ninety","hundred","thousand"]
var level3list

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	messageEntry = $"../TextureRect/MessageEntry"
	display = $"../MessageDisplay"
	level3list = colors+shapes+numbers
	level3list.sort_custom(lengthcomp)
	

func encode(message:String)-> String:
	if globalNode.level ==1:
		return message
	elif globalNode.level ==2 or globalNode.level ==3 :
		if globalNode.version == "A":
			return replaceFromList(message, level3list,"▒▒▒")
		else:
			var arr = message.split()
			for i in range(0,len(arr),2):
				arr[i] = "."
			return  "".join(arr)
	elif globalNode.level == 4:
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
	#for immediate feedback set display directly
	display.messages.append([unencoded, -1, "Sent"])
	display.displaymessages()
	#then send to server
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
		$"../MessageDisplay".emit_signal("levelChanged")
		_on_pressed() #try again
	elif response["message"] == "Failed to Send":
		pass
#assumes list is sorted by string length small to large	
func replaceFromList(input:String, list:Array, replacewith:String)->String:
	if len(list)==0:
		return input
	var replacelen = len(replacewith)
	var i = 0
	while i < len(input):
		var curlen = len(list[0])
		var sub = input.substr(i,curlen)
		for word in list:
			var wordlen = len(word)
			if wordlen>curlen:
				curlen = wordlen
				sub = input.substr(i,curlen)
			if word.to_lower()==sub.to_lower():
				input = input.substr(0,i)+replacewith+input.substr(i+curlen)
		i+=1
	return input

func lengthcomp(a,b)->bool:
	return len(a)<len(b)
