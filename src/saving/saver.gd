class_name Saver
extends Object




static func save_object(target: Object, path: String) -> void:
	var file: FileAccess = FileAccess.open(path, FileAccess.WRITE)
	
	file.store_string(Serializer.serialize(target))
	

static func load_object_from_file(path: String) -> Object:
	var file: FileAccess = FileAccess.open(path, FileAccess.READ)
	
	return Serializer.deserialize(file.get_as_text())
