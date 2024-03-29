extends GutTest


const TESTING_DIR: String = "user://TEST/"
static var TESTING_PATH: String = TESTING_DIR.path_join("testing_save.txt")


func test_saving() -> void:
	var note_list_display: NoteListDisplay = NoteListDisplay.instantiate()
	note_list_display.note_list = NoteList.new([
		Note.new("Première note", "Et sa desc."),
		Note.new("Deuxième note", "Et sa desc aussi."),
	])
	
	var deserialized: NoteListDisplay = Serializer.deserialize(Serializer.serialize(note_list_display))
	
	assert_true(
		note_list_display._is_equal(deserialized), 
		"Serialization and deserialization alters information (on NoteListDisplay)."
	)
	
	Saver.save_object(note_list_display, TESTING_PATH)
	var loaded: NoteListDisplay = Saver.load_object_from_file(TESTING_PATH)
	
	assert_true(
		note_list_display._is_equal(loaded), 
		"Saving and loading alters information (on NoteListDisplay)."
	)
	
	
	note_list_display.free()
	deserialized.free()
	loaded.free()


func test_variable_freed() -> void:
	var start_len: int = len(Variable.all_variables)
	
	Saver.save_object(Variable.new("1+1").set_name("test_variable_freed"), TESTING_PATH)
	
	assert_eq(
		len(Variable.all_variables),
		start_len,
		"Serializing a variable prevent it from being 100% unreferenced."
	)
	
	var _variable = Saver.load_object_from_file(TESTING_PATH)
	
	assert_eq(
		len(Variable.all_variables),
		start_len + 1,
		"Variable is not added to all variables when loaded."
	)
	
	_variable = null
	
	assert_eq(
		len(Variable.all_variables),
		start_len,
		"Variable deserialization prevent right reference count."
	)


func after_all() -> void:
	DirAccess.remove_absolute(TESTING_PATH)
	DirAccess.remove_absolute(TESTING_DIR)
	if DirAccess.dir_exists_absolute(TESTING_DIR):
		fail_test("unable to clean testing directory")
		assert(false, "unable to clean testing directory")
