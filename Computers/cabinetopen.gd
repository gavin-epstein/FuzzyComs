extends Node3D
#@export
#var target = Vector3(-42.3,64.6,65.4) //TODO - animate the opening rotation
func _ready():
	get_tree().current_scene.get_node("Player").clicked.connect(_clicked)

func _clicked(object,player):
	if object ==  $Closed/clickable:
		$Closed.visible=false
		$Closed/clickable.collision_layer = 1
		$Open.visible = true
		$Open/clickable.collision_layer = 3
	elif object == $Open/clickable:
		$Closed.visible=true
		$Closed/clickable.collision_layer = 3
		$Open.visible = false
		$Open/clickable.collision_layer = 1
	
