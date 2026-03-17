extends TextureButton

@export var varname:String


func _on_pressed() -> void:
	DisplayServer.clipboard_set(globalNode.get(varname))
	if DisplayServer.clipboard_get() == globalNode.get(varname):
		$copiedFeedback.visible = true
	
func hide_feedback():
	$copiedFeedback.visible = false
