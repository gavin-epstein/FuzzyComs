extends "res://Computers/FocusScreen.gd"

#override
func _leave_focus():
	$"../..".close() #TODO implement this with signals & make book subscribe (for more flexibility/code reuse)
	focused = false
	extraui.visible = false
	$SubViewport.get_children()[0].notify_focus_changed(false)
	lastplayer.recapture_camera()
