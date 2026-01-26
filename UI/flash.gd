extends Control
@export
var time = 1
var timer

func _ready() -> void:

	timer = Timer.new()
	timer.wait_time = time
	timer.autostart = true
	timer.connect("timeout",blink)
	add_child(timer)
	
	
func blink():
	visible = !visible
#	if visible:
#		timer.wait_time = time
#	else:
#		timer.wait_time = time/2.0
