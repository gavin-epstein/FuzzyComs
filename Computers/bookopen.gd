extends Node3D
@onready
var clickbox = $Closed/clickable
@onready var player = get_tree().current_scene.get_node("Player")

func _ready():
	player.clicked.connect(_clicked)
	globalNode.levelChanged.connect(level_changed)
	clickbox.set_collision_layer_value(2,false)
	

func _clicked(object,_player):
	if object == clickbox:
		$Closed.visible=false
		$Closed/clickable.set_collision_layer_value(2,false)
		$Open.visible = true
		$Open/pagescreen/StaticBody3D.set_collision_layer_value(2, true)
		if $OpenSound != null:
			$OpenSound.play_randomized()
func close():
	$Closed.visible=true
	$Closed/clickable.set_collision_layer_value(2,true)
	$Open.visible = false
	$Open/pagescreen/StaticBody3D.set_collision_layer_value(2,false)

func level_changed():
	if globalNode.level >=2:
		clickbox.set_collision_layer_value(2,true)
