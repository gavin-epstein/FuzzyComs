extends Panel
var oldmousemode = Input.MOUSE_MODE_CAPTURED
@onready var player: Player= get_tree().current_scene.get_node("Player")

func _ready() -> void:
	player.mouseModeChanged.connect(toggleKeyboardShortcut)

func _unhandled_input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("settings"):
		if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED or visible:
			toggle()

func toggleKeyboardShortcut():
	pass #Just leave always visible, bc fails to correctly capture clicking out of the window
	#if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED or visible:
		#$"../GearIcon/Panel/Label".visible = true
	#else:
		#$"../GearIcon/Panel/Label".visible = false

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
	player.mouseModeChanged.emit()

func _on_quit_button_pressed() -> void:
	get_tree().quit()
