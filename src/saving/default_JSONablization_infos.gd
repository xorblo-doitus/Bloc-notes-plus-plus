extends Object
class_name DefaultJSONablizationInfos


static func _static_init():
	create_defaults()


static func create_defaults():
	JSONablizationInfo.new(Note, &"Note", [
		&"title",
		&"description",
		&"other_data",
	])
	JSONablizationInfo.new(Task, &"Task", [
		&"time_limit",
		&"done",
	])
