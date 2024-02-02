extends ConfirmationDialog


func _ready() -> void:
	hide()
	size = 0.7 * DisplayServer.screen_get_size()
	size.x /= 2
	
	var HBox: HBoxContainer = get_ok_button().get_parent()
	HBox.move_child(get_ok_button(), 2)
	HBox.move_child(get_cancel_button(), 1)



func _on_confirmed() -> void:
	EasySettings.save_settings()
