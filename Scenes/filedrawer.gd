extends Node3D
#@export
#var target = Vector3(-42.3,64.6,65.4) //TODO - animate the opening rotation
@export var available_level = 1
var open = false
func _ready():
	get_tree().current_scene.get_node("Player").clicked.connect(_clicked)
	if available_level >1:
		$clickable.set_collision_layer_value(2, false)
		globalNode.levelChanged.connect(level_changed)

func _clicked(object,_player):
	if object ==  $clickable:
		if open:
			$OpenSound.play_randomized()
			rotate_object_local(Vector3.UP,-.5*PI)
			open=false
		else:
			rotate_object_local(Vector3.UP,.5*PI)
			$OpenSound.play_randomized()
			open=true

func level_changed():
	if globalNode.level >=available_level:
		$clickable.set_collision_layer_value(2,true)
