extends Node3D
@onready
var clickbox = $Closed/clickable

func _ready():
	get_tree().current_scene.get_node("Player").clicked.connect(_clicked)

func _clicked(object,player):
	if object == clickbox:
		$Closed.visible=false
		$Closed/clickable.collision_layer = 1
		$Open.visible = true
		$Open/pagescreen.collision_layer = 3
