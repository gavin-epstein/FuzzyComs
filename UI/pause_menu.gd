extends Panel
var oldmousemode = Input.MOUSE_MODE_CAPTURED

func _unhandled_input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("settings"):
		if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED or visible:
			toggle()

func toggle():
	if not visible:
		oldmousemode = Input.mouse_mode
		visible = true
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		get_tree().paused = true
	else:
		visible = false
		Input.set_mouse_mode(oldmousemode)
		get_tree().paused = false

func _on_quit_button_pressed() -> void:
	get_tree().quit()
