class_name ErrorHelper
extends RefCounted


var title: String = ""
var description: String = ""
var godot_builtin_error: Error = FAILED


func _init(_title: String = "", _description: String = "", _godot_builtin_error: Error = FAILED) -> void:
	title = _title
	description = _description
	godot_builtin_error = _godot_builtin_error


## Chainable
func set_title(new: String) -> ErrorHelper:
	title = new
	return self


## Chainable
func set_description(new: String) -> ErrorHelper:
	description = new
	return self


## Chainable
func set_godot_builtin_error(new: Error) -> ErrorHelper:
	godot_builtin_error = new
	return self


func _to_string() -> String:
	var result: String = tr(&"ERROR_PREFIX") + title
	if godot_builtin_error:
		result += " - " + tr("ERROR_STRING").format({
			"godot_builtin_error": godot_builtin_error,
			"error_as_text": error_string(godot_builtin_error)
		})
	
	if description:
		result += "\n" + description
	
	return result


## Craetes a popup displaying this error.
func popup() -> void:
	#var error_popup: ErrorPopup = ErrorPopup.instantiate()
	var title_elements: Array[String] = []
	if title:
		title_elements.append(title)
	if godot_builtin_error != OK:
		title_elements.append(tr("ERROR_STRING").format({
			"godot_builtin_error": godot_builtin_error,
			"error_as_text": error_string(godot_builtin_error)
		}))
	ErrorPopup.set_title_elements(title_elements)
	ErrorPopup.dialog_text = description if description else TranslationServer.tr(&"ERROR_WITHOUT_DESCRIPTION")
	ErrorPopup.show()
	
