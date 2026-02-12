extends SubScreen
@onready
var current = $Alerts


func notify_focus_changed(state:bool)->void:
	if state:
		current.notify_focus_changed(state)
	
func change_to(screen:String):
	var next = get_node(screen)
	if next != null:
		current.visible = false
		current = next
		current.visible = true
		current.notify_focus_changed(true)
