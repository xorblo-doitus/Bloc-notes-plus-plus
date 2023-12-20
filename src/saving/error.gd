extends RefCounted
class_name Error


var title: String = ""
var description: String = ""


func _init(_title: String = "", _description: String = "") -> void:
	title = _title
	description = _description
