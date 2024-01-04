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
