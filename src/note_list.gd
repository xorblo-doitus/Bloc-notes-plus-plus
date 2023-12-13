extends RefCounted

var notes: Array[Note] = []

func add(note: Note) -> void:
	notes.append(note)
