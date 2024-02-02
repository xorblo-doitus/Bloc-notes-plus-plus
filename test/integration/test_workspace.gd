extends GutTest



func test_variable_freed() -> void:
	var start_len: int = len(Variable.all_variables)
	
	var workspace = WorkspaceSave.new()
	workspace.note_list.notes.append(Variable.new("897").set_name("workspace_variable_freed"))
	
	assert_eq(
		len(Variable.all_variables),
		start_len + 1,
		"Workspace don't keep reference to variables."
	)
	
	workspace = null
	
	assert_eq(
		len(Variable.all_variables),
		start_len,
		"Workspace prevent variable reference lost."
	)
