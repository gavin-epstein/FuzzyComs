extends TextureRect


func _on_message_display_unread_messages(count: int) -> void:
	self.visible = true
	$RichTextLabel.text = str(count)
	


func _on_messages_pressed() -> void:
	self.visible = false
