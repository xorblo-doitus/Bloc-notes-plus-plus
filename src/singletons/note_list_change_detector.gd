extends Node


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	for i in len(NoteList.all):
		var note_list: NoteList = NoteList.all[i]
		
		if not is_instance_valid(note_list):
			NoteList.all.remove_at(i)
		
		if note_list._last_notes != note_list.notes:
			note_list.changed.emit(note_list.notes, note_list._last_notes)
			note_list._last_notes = note_list.notes.duplicate()
