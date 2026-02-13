extends SubScreen

var threeinarow = 0
var correct

func _ready() -> void:
	if globalNode.code == null:
		globalNode.code = "12345"
	#press red square
	var color = "red"
	var shape = "square"
	if globalNode.code[0].casecmp_to("C") <0:
	#press red triangle
		color = "red"
		shape = "triangle"
	elif globalNode.code[0].casecmp_to("O")<0:
	#press black circle
		color = "black"
		shape = "circle"
	correct = color+shape

func _on_button_pressed(color: String, shape: String) -> void:
	if color+shape == correct:
		threeinarow+=1
		if threeinarow ==3 and globalNode.level == 2:
			success()
	else:
		threeinarow = 0
		
func success():
	$TextureRect/Panel/Panel/CorrectFeedback.visible = true
	$MessageSender.updateLevel(3);
		
func _http_request_completed(_result, _response_code, _headers, body):
	var json = JSON.new()
	json.parse(body.get_string_from_utf8())
	var response = json.get_data()
	if response == null:
		print(body.get_string_from_utf8())
		return
	if response["message"] == "Level Set":
		globalNode.levelChanged.emit()
