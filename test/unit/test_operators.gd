extends GutTest


func test_is_equal() -> void:
	var note := Note.new()
	note.title = "Titre"
	note.description = "Une description"
	
	var note2 := Note.new()
	note.title = "Titre 2"
	note.description = "Une description"
	
	var variable := Variable.new()
	variable.title = note.title
	variable.description = note.description
	variable.name = "Nom"
	
	var variable2 := Variable.new()
	variable2.title = note.title
	variable2.description = note.description
	variable2.name = "Nom 2"
	
	assert_true(note._is_equal(note), "A note should be equal to itself.")
	assert_true(note2._is_equal(note2), "A note should be equal to itself.")
	
	assert_false(note._is_equal(note2), "A note should not be equal to one with a different title.")
	assert_false(note2._is_equal(note), "A note should not be equal to one with a different title.")
	
	assert_true(variable._is_equal(variable))
	assert_true(variable2._is_equal(variable2))
	
	assert_false(variable._is_equal(variable2), "A variable should not be equal to one with a different name.")
	assert_false(variable2._is_equal(variable), "A variable should not be equal to one with a different name.")
	
	assert_false(note._is_equal(variable), "A variable and a note should not be equal.")
	assert_false(variable._is_equal(note), "A variable and a note should not be equal.")
	
	
	var note_list: NoteList = NoteList.new([note, note2, variable, variable2])
	var note_list_too: NoteList = NoteList.new([note, note2, variable, variable2])
	var note_list2: NoteList = NoteList.new([variable, note2, note, variable2])
	var note_list3: NoteList = NoteList.new([note, note2, variable])
	var note_list4: NoteList = NoteList.new([note, note2, variable, variable2, note])
	
	assert_true(note_list._is_equal(note_list), "A note list should be equal to itself.")
	assert_true(note_list._is_equal(note_list_too), "A note should be equal to one with the same notes.")
	
	assert_false(
		note_list._is_equal(note_list2), 
		"A note list should not be equal to one with notes in another order."
	)
	assert_false(
		note_list2._is_equal(note_list), 
		"A note list should not be equal to one with notes in another order."
	)
	
	assert_false(
		note_list._is_equal(note_list3), 
		"A note list should not be equal to one with less notes."
	)
	assert_false(
		note_list._is_equal(note_list4), 
		"A note list should not be equal to one with more notes."
	)
	
	
	var note_list_display: NoteListDisplay = NoteListDisplay.instantiate()
	note_list_display.note_list = note_list
	
	var note_list_display_too: NoteListDisplay = NoteListDisplay.instantiate()
	note_list_display_too.note_list = note_list_too
	
	var note_list_display2: NoteListDisplay = NoteListDisplay.instantiate()
	note_list_display2.note_list = note_list2
	
	assert_true(
		note_list_display._is_equal(note_list_display),
		"A NoteListDisplay should be equal to itself."
	)
	
	assert_true(
		note_list_display._is_equal(note_list_display_too),
		"A NoteListDisplay should be equal to a similar one."
	)
	
	assert_false(
		note_list_display._is_equal(note_list_display2),
		"A NoteListDisplay should not be equal to a different one."
	)
	
	for to_free: Node in [
		note_list_display,
		note_list_display_too,
		note_list_display2,
	]:
		to_free.free()
