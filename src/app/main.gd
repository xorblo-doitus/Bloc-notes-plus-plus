extends Control


@export var notes_display: NoteListDisplay


func _ready():
	notes_display.notes = DEFAULT_NOTES
