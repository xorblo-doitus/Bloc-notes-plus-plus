class_name Saver
extends Object


static func save_object(target: Object, path: String) -> ErrorHelper:
	DirAccess.make_dir_recursive_absolute(path.get_base_dir())
	
	var file: FileAccess = FileAccess.open(path, FileAccess.WRITE)
	
	if not file:
		var error: ErrorHelper = ErrorHelper.new().set_title(
			TranslationServer.tr(&"ERROR_SAVE_FAILED")
		).set_godot_builtin_error(
			FileAccess.get_open_error()
		)
		
		return error
		#assert(
			#false,
			#"Saving at `" + path + "` failed due to error n°" + str(FileAccess.get_open_error())
			#+ " (" + error_string(FileAccess.get_open_error()) + ")"
		#)
	
	file.store_string(Serializer.serialize(target))
	
	return null


## If something goes wrong, returns [code]null[/code]
static func load_object_from_file(path: String) -> Object:
	var file: FileAccess = FileAccess.open(path, FileAccess.READ)
	
	if file == null:
		var error: ErrorHelper = ErrorHelper.new().set_title(
			TranslationServer.tr(&"ERROR_LOAD_FAILED")
		).set_godot_builtin_error(
			FileAccess.get_open_error()
		)
		
		return error
	
	return Serializer.deserialize(file.get_as_text())
