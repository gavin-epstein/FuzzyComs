extends SubScreen

var mouseInput : Vector2 = Vector2(0,0)
	

		
func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		mouseInput = event.position
	#	$mousetracker.set_position(mouseInput)
	if event is InputEventMouseButton:
		pass
	#	print(mouseInput)

func notify_focus_changed(state:bool)->void:
	if state:
		$TextureRect/MessageEntry.grab_focus.call_deferred()
#automatically send message
func _on_text_changed() -> void:
	var text = $TextureRect/MessageEntry.text
	if text.ends_with('\n'):
		$TextureRect/MessageEntry.text = text.left(text.length()-1)
		$"SendButton"._on_pressed()
		
func _http_request_completed(_result, response_code, headers, body):
	pass
