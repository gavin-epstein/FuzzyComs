extends MeshInstance3D

func _ready() -> void:
	$"../screen/SubViewport/Control".dialMoved.connect(setdial)
	
func setdial(angle):
	rotation.x=angle+PI/2
