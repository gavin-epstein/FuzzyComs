extends Node3D
var lastplayer

	
	
func enter(player):
	globalNode.level = 3
	print(globalNode.level)
	get_viewport().get_camera_3d().current = false
	$Camera.current = true
	player.release_mouse()
	lastplayer = player
	$Control.visible = true
	
	
func exit():
	lastplayer.recapture_camera()
	queue_free()
	
