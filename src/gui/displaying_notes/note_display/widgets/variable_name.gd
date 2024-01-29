class_name WidgetVariableName
extends DisplayWidget


static var equal_string: String = "= "


@onready var name_label: RichTextEdit = %Name
@onready var equal: Label = %Equal
@onready var error_button: ErrorButton = %ErrorButton


func _connect_to(_note: Note) -> void:
	super(_note)
	
	_connections.append(Connection.new(_note.name_changed, update_name, true))
	update_name()


func update_name() -> void:
	name_label.text = str(note.name)
	# Temporary fix
	name_label.custom_minimum_size.x = 9 * len(name_label.text)
	equal.text = WidgetVariableName.equal_string
	check_name(note.name)


func _on_name_text_changed(new: String, _old: String) -> void:
	note.name = new
	check_name(new)


## Return true if the name is valid
func check_name(_name: String) -> bool:
	if not _name.is_valid_identifier():
		error_button.error = ErrorHelper.new().set_title(
			tr("ERROR_INVALID_IDENTIFIER")
		).set_description(
			tr("ERROR_INVALID_IDENTIFIER_DESC").format({
				"identifier": _name,
			})
		)
		return false
	
	error_button.error = null
	return true
