class_name WidgetCalculusResult
extends DisplayWidget


static var equal_string = " ="

@onready var result: Label = %Result
@onready var error_button: ErrorButton = %ErrorButton


func _connect_to(_note: Note) -> void:
	super(_note)
	
	_connections.append(Connection.new(_note.title_changed, update_value.unbind(2), true))
	_connections.append(Connection.new(_note.error_changed, update_error, true))
	update_value()


func update_value() -> void:
	result.text = str(note.value) + WidgetCalculusResult.equal_string


func update_error(error: ErrorHelper = note.error) -> void:
	error_button.error = error
	if note.error:
		result.add_theme_color_override(&"font_color", get_theme_color(&"font_placeholder_color", &"LineEdit"))
	else:
		result.remove_theme_color_override(&"font_color")
