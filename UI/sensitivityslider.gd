extends HSlider



@onready var player: Player= get_tree().current_scene.get_node("Player")


func _ready() -> void:
	#value = db_to_linear(AudioServer.get_bus_volume_db(_bus))
	value = player.mouse_sensitivity

func _on_HSlider_value_changed(val: float) -> void:
	player.mouse_sensitivity = val
