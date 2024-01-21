class_name WidgetCalculusResult
extends DisplayWidget


static var equal_string = " ="

@onready var result: Label = %Result
@onready var error_button: TextureButton = %ErrorButton


func _connect_to(_note: Note) -> void:
	super(_note)
	
	_connections.append(Connection.new(_note.title_changed, update_value.unbind(2), true))
	update_value()


func update_value() -> void:
	if note.error:
		error_button.tooltip_text = str(note.error)
		result.add_theme_color_override(&"font_color", get_theme_color(&"font_placeholder_color", &"LineEdit"))
		error_button.show()
	else:
		result.text = str(note.value) + WidgetCalculusResult.equal_string
		result.remove_theme_color_override(&"font_color")
		error_button.hide()


func _on_error_button_pressed() -> void:
	if note.error:
		note.error.popup()
