extends Node3D
var lastplayer

	
	
func enter(player):
	get_viewport().get_camera_3d().current = false
	$Camera.current = true
	player.release_mouse()
	lastplayer = player
	visible = true
	
func exit():
	lastplayer.recapture_camera()
	queue_free()
	
