extends TextureRect

# Called when the node enters the scene tree for the first time.
func _ready() -> void:

	var timer = Timer.new()
	timer.wait_time = 1.5
	timer.autostart = true
	timer.connect("timeout",fetch)
	add_child(timer)


func fetch():
	$MessageSender.getMessages()
	
func _http_request_completed():
	pass
