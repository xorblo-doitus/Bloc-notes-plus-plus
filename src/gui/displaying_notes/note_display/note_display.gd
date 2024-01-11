class_name NoteDisplay
extends PanelContainer


signal title_changed(new: String, old: String)
## Emitted when delete button is pressed, etc...
signal request_remove()

## Texte principal de la note et celui qui est affiché dans la liste de note.
var title: String = "":
	set(new):
		title = new
		%Title.text = new

## Texte descriptif plus étoffé que le titre.
var description: String = "":
	set(new):
		description = new
		%Title.tooltip_text = new


@warning_ignore("unused_private_class_variable")
var _connections: Array[Connection]
var connected_to: Note


## A reference to the default packed scene associated with this class
static var _default_scene: PackedScene:
	get:
		if _default_scene == null:
			_default_scene = load("res://src/gui/displaying_notes/note_display/note_display.tscn")
		return _default_scene

## Create a new instance by loading default scene for this class.
static func instantiate() -> NoteDisplay:
	return _default_scene.instantiate()


func _on_title_text_changed(new, _old):
	# We use the old text of this NoteDisplay just in case it was changed while edited by user.
	var old: String = title
	title = new
	title_changed.emit(new, old)




func _on_delete_pressed() -> void:
	request_remove.emit()
