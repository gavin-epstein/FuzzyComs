extends Node3D
class_name SceneRoot
var endscreen = preload("res://Scenes/GameOver.tscn")

func _ready():
	globalNode.levelChanged.connect(level_changed)

func level_changed():
	print("level", globalNode.level)
	if globalNode.level == 2:
		$Cutscene.enter($Player)
	if globalNode.level == 4:
		get_tree().change_scene_to_packed(endscreen)
