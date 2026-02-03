extends Node3D
class_name SceneRoot

func level_changed():
	if globalNode.level == 2:
		$Cutscene.enter($Player)
