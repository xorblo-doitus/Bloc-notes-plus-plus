class_name NoteDisplay
extends PanelContainer


## Emitted when delete button is pressed, etc...
signal request_remove()

## Texte principal de la note et celui qui est affiché dans la liste de note.
var title: String = "":
	set(new):
		if new == title:
			return
		title = new
		%Title.text = new

## Texte descriptif plus étoffé que le titre.
var description: String = "":
	set(new):
		if new == description:
			return
		description = new
		%Title.tooltip_text = new


@warning_ignore("unused_private_class_variable")
var _connections: Array[Connection]
var _displaying: Note


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
	title = note.title
	description = note.description
	
	_connections.append(Connection.new(note.title_changed, _on_note_title_changed, true))
	_connections.append(Connection.new(note.description_changed, _on_note_description_changed, true))
	
	_displaying = note


func undisplay() -> void:
	if  _displaying == null:
		return
	
	while _connections:
		_connections.pop_back().destroy()
	
	_displaying = null


func _on_note_title_changed(new: String, _old: String) -> void:
	title = new


func _on_note_description_changed(new: String, _old: String) -> void:
	description = new


func _on_title_text_changed(new: String, _old: String):
	#_displaying.title = new
	pass


func _on_delete_pressed() -> void:
	request_remove.emit()
