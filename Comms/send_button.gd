extends Button

var messageEntry:TextEdit
var display
var colors = ["red","orange","white", "black", "green","yellow", "blue","purple", "pink", "brown", "grey", "gray","color","colour","红", "黑", "白","绿",'色',"yanse","rojo","roja","verde","blanco","blanca","negro","negra","rouge","blanc","verre"]
var shapes = ["circle", "triangle", "square", "cross", "pentagon","diamond", "rectangle", "rhombus", "quadrilateral", "oval", "ellipse", "star","shape"]
var numbers = ["number","1","2","3","4","5","6","7","8","9","0","one","two","three","four","five","six","seven","eight","nine","ten","eleven","twelve","thirteen", "fourteen","fifteen","sixteen","seventeen", "eighteen", "nineteen", "twenty", "thirty","fourty", "forty","fifty", "sixty","seventy","eighty","ninety","hundred","thousand","一","二","三","四","五","六","七","八","九","十","百","uno","dos","tres","quatro","cinco","seis","siete","ocho","nueve","dies","once","doce","trece","catorce","quince","viente","trienta",'cien',"deux","trois","quatre","cinq","sept","huit","neuf","dix", "onze","douze","treize","quatorze","quinze","seize", "vingt","cent","yi","san","wu","liu","qi","jiu","shi","bai","yao"]
var punct = "., -_+=;:'"+'"'
var level2list
var level3list
var lastSent:String

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	messageEntry = $"../TextureRect/MessageEntry"
	display = $"../MessageDisplay"
	level2list = colors+shapes
	level2list.sort_custom(lengthcomp)
	level3list = numbers
	level3list.sort_custom(lengthcomp)
	

func encode(message:String)-> String:
	if globalNode.level ==1:
		return message
	elif  globalNode.level ==2 :
		if globalNode.version == "A" || globalNode.version =="C":
			return replaceFromList(message, level2list,"***")
		else:
			var arr = message.split(" ")
			for i in [0, len(arr)-1]: 
				var st=""
				for _j in range(len(arr[i])):
					st+="*"
				arr[i] = st
			return  " ".join(arr)
	elif globalNode.level == 3:
		if globalNode.version == "A" || globalNode.version == "D":
			message = message.remove_chars(punct)
			return replaceFromList(message, level3list,"*")
		else:
			var arr = message.split(" ")
			for i in range(0,len(arr),2): 
				var st=""
				for _j in range(len(arr[i])):
					st+="*"
				arr[i] = st
			return  " ".join(arr)
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
	display.messages.append([unencoded, "LAST", "Sent"])
	display.displaymessages(true)
	messageEntry.text = ''
	#save in case of race condition
	lastSent = unencoded
	#then send to server
	$MessageSender.sendMessage(globalNode.code, body);

func _http_request_completed(_result, _response_code, _headers, body):
	var json = JSON.new()
	json.parse(body.get_string_from_utf8())
	var response = json.get_data()
	if response == null:
		print(body.get_string_from_utf8())
		return
	if response["message"] == "Message Sent":
		pass
	elif response["message"] == "Level out of Sync":
		if int(response['Level']) > globalNode.level:
			globalNode.level = int(response['Level'])
			globalNode.levelChanged.emit()			
			_on_pressed() #try again
		else:
			#wait for things to catch up and try again?
			await get_tree().create_timer(3.0).timeout
			_on_pressed()
	elif response["message"] == "Failed to Send":
		pass
#assumes list is sorted by string length small to large	
func replaceFromList(input:String, list:Array, replacewith:String)->String:
	if len(list)==0:
		return input
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
