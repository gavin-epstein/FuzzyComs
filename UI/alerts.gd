extends SubScreen
signal unread_messages(count:int)

func _ready() -> void:
	globalNode.levelChanged.connect(level_changed)

func level_changed():
	if globalNode.level == 2:
		$Panel/damage.visible = true
	if not is_visible_in_tree():
		unread_messages.emit(1)
