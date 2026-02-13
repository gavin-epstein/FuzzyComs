extends Node3D
class_name SceneRoot
var endscreen = preload("res://Scenes/GameOver.tscn")
var cutscene_entered = false
func _ready():
	globalNode.levelChanged.connect(level_changed)

func level_changed():
	print("level", globalNode.level)
	if globalNode.level == 2:
		if !cutscene_entered:
			cutscene_entered=true
			$Cutscene.enter($Player)
	if globalNode.level == 3:
		get_tree().change_scene_to_packed(endscreen)
