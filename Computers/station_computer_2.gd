extends SubScreen




func _on_popup_close_pressed() -> void:
	$Panel/Popup.visible = false
	$Panel/RestorePopupButton.visible = true


func _on_restore_popup_button_pressed() -> void:
	$Panel/Popup.visible = true
	$Panel/RestorePopupButton.visible = false
