extends RefCounted
class_name ErrorHelper


var title: String = ""
var description: String = ""


func _init(_title: String = "", _description: String = "") -> void:
	title = _title
	description = _description


## Craetes a popup displaying this error.
func popup() -> void:
	pass
