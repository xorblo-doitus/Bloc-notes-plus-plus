extends Node

## A singleton detecting [NoteList] note changement.
## 
## As arrays don't have a changed signal, this is the easiest way to do it.
## Moreover it prevent infinite callback call as this signal can be emitted
## only one time per frame.


## Check every frame each [NoteList] to detect if their content changed
func _process(_delta):
	NoteList.all = NoteList.all.filter(ST.is_ref_valid)
	
	for i in len(NoteList.all):
		var note_list: NoteList = NoteList.all[i].get_ref()
		
		if not is_instance_valid(note_list):
			continue
		
		if note_list._last_notes != note_list.notes:
			note_list.changed.emit(note_list.notes, note_list._last_notes)
			note_list._last_notes = note_list.notes.duplicate()
