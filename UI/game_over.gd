extends Control


func _ready() -> void:
	$Panel/RichTextLabel.text = $Panel/RichTextLabel.text % globalNode.code
