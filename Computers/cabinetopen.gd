extends Node3D
#@export
#var target = Vector3(-42.3,64.6,65.4) //TODO - animate the opening rotation
func _ready():
	get_tree().current_scene.get_node("Player").clicked.connect(_clicked)

func _clicked(object,player):
	if object ==  $Closed/clickable:
		$Closed.visible=false
		$Closed/clickable.set_collision_layer_value(2, false)
		$Open.visible = true
		$Open/clickable.set_collision_layer_value(2, true)
	elif object == $Open/clickable:
		$Closed.visible=true
		$Closed/clickable.set_collision_layer_value(2,false)
		$Open.visible = false
		$Open/clickable.set_collision_layer_value(2, true)
	
