extends Node3D
class_name SceneRoot

func level_changed():
	if globalNode.level == 2:
		#cutscene
		#TODO: change camera to cutscene cam
		#or use a ui node popup with prerendered video?
		#start cutscene
		#on timer finished, change back
		pass
