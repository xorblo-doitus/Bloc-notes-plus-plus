extends Control


static var DEFAULT_NOTES: Array[Note] = [Note.new("Exemple de note.", "Ceci est une description.")]
@export var notes_display: NoteListDisplay


func _ready():
	notes_display.notes = DEFAULT_NOTES
