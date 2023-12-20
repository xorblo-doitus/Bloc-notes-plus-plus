extends Object
class_name DefaultJSONablizationInfos


static func _static_init():
	create_defaults()


static func create_defaults():
	var _note := JSONablizationInfo.new(Note, &"Note", [
		&"title",
		&"description",
		&"other_data",
	]).build()
	
	var _task := JSONablizationInfo.new(Task, &"Task", [
		&"time_limit",
		&"done",
	]).set_inherit(_note).build()
