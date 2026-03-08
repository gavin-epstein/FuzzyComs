extends Node3D
#@export
#var target = Vector3(-42.3,64.6,65.4) //TODO - animate the opening rotation
@export var available_level = 1
func _ready():
	get_tree().current_scene.get_node("Player").clicked.connect(_clicked)
	if available_level >1:
		$Closed/clickable.set_collision_layer_value(2, false)
		globalNode.levelChanged.connect(level_changed)

func _clicked(object,_player):
	if object ==  $Closed/clickable:
		$Closed.visible=false
		$Closed/clickable.set_collision_layer_value(2, false)
		$Open.visible = true
		$Open/clickable.set_collision_layer_value(2, true)
		$OpenSound.play_randomized()
	elif object == $Open/clickable:
		$Closed.visible=true
		$Closed/clickable.set_collision_layer_value(2,true)
		$Open.visible = false
		$Open/clickable.set_collision_layer_value(2, false)
		$CloseSound.play_randomized()

func level_changed():
	if globalNode.level >=available_level:
		$Closed/clickable.set_collision_layer_value(2,true)
