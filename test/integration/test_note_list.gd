extends GutTest



func test_variable_freed() -> void:
	var start_len: int = len(Variable.all_variables)
	
	var note_list = NoteList.new()
	note_list.notes.append(Variable.new("897").set_name("workspace_variable_freed"))
	
	assert_eq(
		len(Variable.all_variables),
		start_len + 1,
		"NoteList don't keep reference to variables."
	)
	
	note_list = null
	
	assert_eq(
		len(Variable.all_variables),
		start_len,
		"NoteList prevent variable reference lost."
	)
