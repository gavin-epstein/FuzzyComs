extends SubScreen

var angle = 0;
var mouseDown=false
signal dialMoved(val)
var allowed=false
var correct

func _ready() -> void:
	correct = 83
	if globalNode.otherCode[0].casecmp_to("0") <0:
	#press red triangle
		correct = 93
	elif globalNode.otherCode[0].casecmp_to("H")<0:
	#press black circle
		correct = 103
	elif globalNode.otherCode[0].casecmp_to("Q")<0:
		correct = 113

#allowed stops the click of getting into the window from counting for the dial. 
func notify_focus_changed(_state:bool)->void:
	allowed = false

func _input(event: InputEvent) -> void:
	if not allowed:
		allowed = true
		return
	if event is InputEventMouseButton:
		mouseDown = event.pressed
	if event is InputEventMouse and mouseDown:
		var inangle = (event.position - Vector2(256,256)).angle()
		if inangle <0 and inangle > -PI:
			angle = inangle
			dialMoved.emit(angle)
			set_text(angle)

func set_text(val):
	var freq = map(angle,-PI,0, 80,120)
	$Panel/Panel/FreqDisplay.text = str(int(freq)) + " MHz" 
	#$Panel/Panel2.rotation = angle
	
static func map(v:float,a1,a2,b1,b2):
	var r= (v-a1)/(a2-a1)
	return b1+(b2-b1)*r
	
		


func _on_test_button_pressed() -> void:
	var freq = int(map(angle,-PI,0, 80,120))
	if freq != correct:
		$Panel/Panel/FreqDisplay.text = "ERR"
	else:
		$Panel/Panel/FreqDisplay.text = "Connected!"
		$MessageSender.updateLevel(4)


func _http_request_completed(_result, _response_code, _headers, body):
	var json = JSON.new()
	json.parse(body.get_string_from_utf8())
	var response = json.get_data()
	if response == null:
		print(body.get_string_from_utf8())
		return
	if response["message"] == "Level Set":
		globalNode.levelChanged.emit()
