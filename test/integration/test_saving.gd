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
	

func after_all() -> void:
	DirAccess.remove_absolute(TESTING_DIR)
