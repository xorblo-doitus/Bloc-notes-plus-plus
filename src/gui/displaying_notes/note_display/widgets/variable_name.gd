class_name WidgetVariableName
extends DisplayWidget


static var equal_string: String = "= "


@onready var name_label: RichTextEdit = %Name
@onready var equal: Label = %Equal


func _connect_to(_note: Note) -> void:
	super(_note)
	
	_connections.append(Connection.new(_note.name_changed, update_name, true))
	update_name()


func update_name() -> void:
	name_label.text = str(note.name)
	# Temporary fix
	name_label.custom_minimum_size.x = 9 * len(name_label.text)
	equal.text = WidgetVariableName.equal_string


func _on_name_text_changed(new: String, _old: String) -> void:
	note.name = new
	
