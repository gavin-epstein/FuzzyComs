extends SubScreen


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if globalNode.code == null:
		globalNode.code = "12345"
	#press red square
	var color = "Green"
	var shape = "Circle"
	if globalNode.code[0].casecmp_to("C") <0:
	#press red triangle
		color = "Black"
		shape = "Square"
	elif globalNode.code[0].casecmp_to("O")<0:
	#press black circle
		color = "White"
		shape = "Triangle"
	$Page1/RichTextLabel.text = $Page1/RichTextLabel.text % [color, shape]
