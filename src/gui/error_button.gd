class_name ErrorButton
extends TextureButton


## A button letting showing an error to the user.
## 
## Once clicked, opens a popup to show more informations about the error.


var error: ErrorHelper:
	set(new):
		error = new
		update()


func _ready() -> void:
	update()


func update() -> void:
	if error:
		show()
		tooltip_text = str(error)
		match error.level:
			ErrorHelper.Level.WARNING:
				modulate = Color.YELLOW
			ErrorHelper.Level.ERROR:
				modulate = Color.RED
	else:
		hide()


func _on_pressed() -> void:
	if error:
		error.popup()
