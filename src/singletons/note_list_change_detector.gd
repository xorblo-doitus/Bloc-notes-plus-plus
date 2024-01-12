extends Node

## A singleton detecting [NoteList] note changement.
## 
## As arrays don't have a changed signal, this is the easiest way to do it.
## Moreover it prevent infinite callback call as this signal can be emitted
## only one time per frame.


## Check every frame each [NoteList] to detect if their content changed
func _process(_delta):
	for i in len(NoteList.all):
		var note_list: NoteList = NoteList.all[i]
		
		if not is_instance_valid(note_list):
			NoteList.all.remove_at(i)
		
		if note_list._last_notes != note_list.notes:
			note_list.changed.emit(note_list.notes, note_list._last_notes)
			note_list._last_notes = note_list.notes.duplicate()
