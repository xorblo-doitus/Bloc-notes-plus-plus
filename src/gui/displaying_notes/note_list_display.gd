class_name NoteListDisplay
extends PanelContainer


static func instantiate() -> NoteListDisplay:
	var new: NoteListDisplay = preload("res://src/gui/displaying_notes/note_list_display.tscn").instantiate()
	return new
