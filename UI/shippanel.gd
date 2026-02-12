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
		if threeinarow ==3 and globalNode.level == 3:
			success()
	else:
		threeinarow = 0
		
func success():
	$TextureRect/Panel/Panel/CorrectFeedback.visible = true
	$MessageSender.updateLevel(4);
		
func _http_request_completed(_result, response_code, headers, body):
	pass
