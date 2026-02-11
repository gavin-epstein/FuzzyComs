extends SubScreen


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if globalNode.code == null:
		globalNode.code = "12345"
	var regnum = "MU"+globalNode.code.sha1_text().substr(0,3)
	$Page1/RichTextLabel.text = $Page1/RichTextLabel.text % [regnum]


func _on_next_pressed() -> void:
	$Page1.visible=false


func _on_prev_pressed() -> void:
	$Page1.visible=true
