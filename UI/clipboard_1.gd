extends SubScreen


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if globalNode.code == null:
		globalNode.code = "12345"
	var regnum = "MU"+globalNode.code.sha1_text().substr(0,3).replace("0","1").replace("o","t").replace("5","6").replace("s","f").to_lower()
	$Page1/RichTextLabel.text = $Page1/RichTextLabel.text % [regnum]


func _on_next_pressed() -> void:
	$Page1.visible=false
	$AudioStreamPlayer.play_randomized()


func _on_prev_pressed() -> void:
	$Page1.visible=true
	$AudioStreamPlayer.play_randomized()

#func _input(event):
#	if event is InputEventMouseMotion:
#		$Panel.position = event.position

func notify_focus_changed(state:bool)->void:
	if not state:
		$Page1.visible=false
