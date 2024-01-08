class_name Saver
extends Object




static func save_object(target: Object, path: String) -> void:
	DirAccess.make_dir_recursive_absolute(path.get_base_dir())
	
	var file: FileAccess = FileAccess.open(path, FileAccess.WRITE)
	
	if not file:
		assert(
			false,
			"Saving at `" + path + "` failed due to error n°" + str(FileAccess.get_open_error())
			+ " (" + error_string(FileAccess.get_open_error()) + ")"
		)
	
	file.store_string(Serializer.serialize(target))
	

static func load_object_from_file(path: String) -> Object:
	var file: FileAccess = FileAccess.open(path, FileAccess.READ)
	
	return Serializer.deserialize(file.get_as_text())
