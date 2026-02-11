extends Node3D
@onready
var clickbox = $Closed/clickable

func _ready():
	get_tree().current_scene.get_node("Player").clicked.connect(_clicked)

func _clicked(object,player):
	if object == clickbox:
		$Closed.visible=false
		$Closed/clickable.set_collision_layer_value(2,false)
		$Open.visible = true
		$Open/pagescreen/StaticBody3D.set_collision_layer_value(2, true)
func close():
	$Closed.visible=true
	$Closed/clickable.set_collision_layer_value(2,true)
	$Open.visible = false
	$Open/pagescreen/StaticBody3D.set_collision_layer_value(2,false)
