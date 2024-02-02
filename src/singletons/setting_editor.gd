extends ConfirmationDialog


func _ready() -> void:
	hide()
	size = 0.7 * DisplayServer.screen_get_size()
	size.x /= 2



func _on_confirmed() -> void:
	EasySettings.save_settings()
