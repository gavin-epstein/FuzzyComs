extends Control
var lastplayer

	
	
func enter(player):
#	get_viewport().get_camera_3d().current = false
#	$Camera.current = true
	player.release_mouse()
	lastplayer = player
	visible = true
	$Panel/VideoStreamPlayer.play()
	
	
func exit():
	lastplayer.recapture_camera()
	queue_free()
	
