extends Control

@export
var color:String
@export
var shape:String
func _ready():
	$Page1/Leaf1.text = $Page1/Leaf1.text % [color, shape]


func _on_next_pressed() -> void:
	$Page1.visible=false
