class_name NoteListDisplay
extends PanelContainer


## The notes displayed.
## [br][br][b]READONLY[/b]: Trying to modifying this attribute will only set it's
## [member NoteList.notes] to a [i]copy[/i] of the new one's [member NoteList.notes]
var note_list: NoteList = NoteList.new():
	set(new):
		note_list.notes = new.notes.duplicate()

## Shortcut for [member note_list].notes, see [member NoteList.notes]
var notes: Array[Note]:
	set(new):
		note_list.notes = new.duplicate()
	get:
		return note_list.notes


## Create a new instance by loading default scene for this class.
static func instantiate() -> NoteListDisplay:
	var new: NoteListDisplay = preload("res://src/gui/displaying_notes/note_list_display.tscn").instantiate()
	return new
