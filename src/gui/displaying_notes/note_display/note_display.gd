class_name NoteDisplay
extends PanelContainer


## Emitted when delete button is pressed, etc...
signal request_remove()


@warning_ignore("unused_private_class_variable")
var _connections: Array[Connection]
var _displaying: Note


@onready var title: EditableRichTextLabel = %Title
@onready var grip_component: GripComponent = %GripComponent


## A reference to the default packed scene associated with this class
static var _default_scene: PackedScene:
	get:
		if _default_scene == null:
			_default_scene = load("res://src/gui/displaying_notes/note_display/note_display.tscn")
		return _default_scene

## Create a new instance by loading default scene for this class.
static func instantiate() -> NoteDisplay:
	return _default_scene.instantiate()


func display(note: Note) -> void:
	if not is_node_ready():
		ready.connect(display.bind(note), CONNECT_ONE_SHOT)
		return
	
	_displaying = note
	
	_on_note_title_changed()
	_on_note_description_changed()
	
	_connections.append(Connection.new(note.title_changed, _on_note_title_changed.unbind(2), true))
	_connections.append(Connection.new(note.description_changed, _on_note_description_changed.unbind(2), true))


func undisplay() -> void:
	if  _displaying == null:
		return
	
	while _connections:
		_connections.pop_back().destroy()
	
	_displaying = null


func _on_note_title_changed() -> void:
	title.text = _displaying.title


func _on_note_description_changed() -> void:
	title.tooltip_text = _displaying.description


func _on_title_text_changed(new: String, _old: String):
	_displaying.title = new


func _on_delete_pressed() -> void:
	request_remove.emit()
