class_name NoteDisplay
extends Panel


signal title_changed(new: String, old: String)


## Texte principal de la note et celui qui est affiché dans la liste de note.
var title: String = "":
	set(new):
		title = new
		%Title.text = new

## Texte descriptif plus étoffé que le titre.
var description: String = "":
	set(new):
		description = new


@warning_ignore("unused_private_class_variable")
var _connections: Array[Connection]


static func instantiate() -> NoteDisplay:
	var new: NoteDisplay = preload("res://src/note/note_display.tscn").instantiate()
	return new


func _on_title_text_changed(new, _old):
	# We use the old text of this NoteDisplay just in case it was changed while edited by user.
	var old: String = title
	title = new
	title_changed.emit(new, old)


