extends Node3D

@export var speed:float = 5

func _process(delta: float) -> void:
	position+=(Vector3(-1*speed*delta,0,0))
	if position.x < -100:
		position.x = 300
