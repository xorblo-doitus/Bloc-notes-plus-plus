extends Control


static var DEFAULT_NOTES: Array[Note] = [Note.new("Exemple de note.", "Ceci est une description.")]
@export var notes: NoteListDisplay


func _ready():
	notes.notes = DEFAULT_NOTES
