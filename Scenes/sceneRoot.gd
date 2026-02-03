extends Node3D
class_name SceneRoot

func _ready():
	globalNode.levelChanged.connect(level_changed)

func level_changed():
	print("level", globalNode.level)
	if globalNode.level == 2:
		$Cutscene.enter($Player)
