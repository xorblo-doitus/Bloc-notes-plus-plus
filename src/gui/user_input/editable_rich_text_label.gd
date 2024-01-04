class_name EditableRichTextLabel
extends RichTextLabel


signal text_changed(new: String, old: String)


## If true, text will be submitted only when enter is pressed while shift too.
## This helps to edit multiline texts.
## This will also enable other features.
@export var multiline: bool = true:
	set(new):
		%CodeEdit.gutters_draw_line_numbers = new
## If true, text will be submitted only when enter is pressed while shift too.
## This helps to edit multiline texts.
#@export var shift_to_validate: bool = true


var editing: bool = false:
	set(new):
		editing = new
		if new:
			%CodeEdit.grab_focus.call_deferred()
			%CodeEdit.text = text
			_last_text = text
			text = ""
		else:
			text = %CodeEdit.text
			%CodeEdit.text = ""
			if text != _last_text:
				text_changed.emit(text, _last_text)
		
		# Do it at the end
		%CodeEdit.visible = new


var _last_text: String = text


static func instantiate() -> EditableRichTextLabel:
	return load("res://src/gui/user_input/editable_rich_text_label.tscn").instantiate()


func _ready():
	var starting_text: String = text
	
	editing = false
	
	# Triger setters
	multiline = multiline
	
	self.text = starting_text


#func _set(property, value):
	#if property == &"text":
		#%CodeEdit.text = text


func get_text_stored() -> String:
	if editing:
		return _last_text
	else:
		return text



func _on_code_edit_text_changed():
	#text = %CodeEdit.text
	pass


func _gui_input(event: InputEvent):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.double_click and event.pressed:
			editing = true


func _on_code_edit_text_set():
	pass
	#editing = false
	#text = %CodeEdit.text


func _on_code_edit_gui_input(event: InputEvent):
	if event is InputEventKey and event:
		if multiline and event.is_action(&"validate_input", true):
			%CodeEdit.hide()


func _on_code_edit_focus_exited():
	%CodeEdit.hide()


func _on_code_edit_visibility_changed():
	print(%CodeEdit.visible)
	if !%CodeEdit.visible:
		editing = false
