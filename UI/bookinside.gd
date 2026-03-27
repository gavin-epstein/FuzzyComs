extends SubScreen

@export
var color:String
@export
var shape:String
func _ready():
	$Page1/Leaf1.text = $Page1/Leaf1.text % [color, shape]


#func _input(event: InputEvent) -> void:
#	if event is InputEventMouseMotion:
#		$Page1/Next.position = event.position

func _on_next_pressed() -> void:
	$Page1.visible=false
	$PageSound.play_randomized()



func _on_prev_pressed() -> void:
	$Page1.visible = true
	$PageSound.play_randomized()
	
func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("D") and $Page1.visible:
		_on_next_pressed()
	elif Input.is_action_just_pressed("A") and !$Page1.visible:
		_on_prev_pressed()
		
