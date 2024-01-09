extends RefCounted
class_name ErrorHelper


var title: String = ""
var description: String = ""
var godot_builtin_error: Error = FAILED


func _init(_title: String = "", _description: String = "", _godot_builtin_error: Error = FAILED) -> void:
	title = _title
	description = _description
	godot_builtin_error = _godot_builtin_error


## Craetes a popup displaying this error.
func popup() -> void:
	#var error_popup: ErrorPopup = ErrorPopup.instantiate()
	ErrorPopup.title = title
	ErrorPopup.dialog_text = description
	ErrorPopup.popup()
	
