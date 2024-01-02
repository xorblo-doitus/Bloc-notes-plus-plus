extends GutTest


func test_note_list():
	var note_list: NoteList = NoteList.new()
	watch_signals(note_list)
	
	assert_signal_not_emitted(note_list, "changed", "Changed was emited at creation.")
	
	for __ in 5:
		await get_tree().process_frame
	
	assert_signal_not_emitted(note_list, "changed", "Changed was emited while waiting.")
	
	note_list.notes.push_back(Note.new())
	
	await get_tree().process_frame
	assert_signal_emit_count(note_list, "changed", 1, "Changed was not emited by push_back.")
	
	await get_tree().process_frame
	assert_signal_emit_count(note_list, "changed", 1, "Changed was emited while waiting.")
	
	
	note_list.notes[0] = Note.new()
	
	await get_tree().process_frame
	assert_signal_emit_count(note_list, "changed", 2, "Changed was not emited by modifying an element.")
	
	
	note_list.notes.pop_back()
	
	await get_tree().process_frame
	assert_signal_emit_count(note_list, "changed", 3, "Changed was not emited by pop_back.")
