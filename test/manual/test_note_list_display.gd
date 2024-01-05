extends Control



func _ready() -> void:
	var notes: Array[Note] = [
		Note.new("Première note", "Une description succinte"),
		Note.new(),
		Note.new("Bah, la note précédente n'a pas de titre ?!", "(C'est pour tester.)"),
	]
	
	
	$NoteListDisplay.notes = notes
