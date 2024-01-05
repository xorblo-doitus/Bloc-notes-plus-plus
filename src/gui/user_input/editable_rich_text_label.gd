@tool
class_name EditableRichTextLabel
extends RichTextLabel


signal text_changed(new: String, old: String)


## If true, text will be submitted only when enter is pressed while shift too.
## This helps to edit multiline texts.
## This will also enable other features.
@export var multiline: bool = true:
	set(new):
		multiline = new
		%CodeEdit.gutters_draw_line_numbers = new
		fit_content = not new
		%CodeEdit.scroll_fit_content_height = not new
		#code_edit.fit
## If true, text will be submitted only when enter is pressed while shift too.
## This helps to edit multiline texts.
#@export var shift_to_validate: bool = true


var editing: bool = false:
	set(new):
		editing = new
		if new:
			code_edit.grab_focus.call_deferred()
			code_edit.text = text
			_last_text = text
			text = " "
		else:
			text = code_edit.text
			code_edit.text = " "
			if text != _last_text:
				text_changed.emit(text, _last_text)
		
		# Do it at the end
		code_edit.visible = new


var _last_text: String = text


@onready var code_edit: CodeEdit = %CodeEdit


static func instantiate() -> EditableRichTextLabel:
	return load("res://src/gui/user_input/editable_rich_text_label.tscn").instantiate()


func _ready():
	if text == "":
		text = " "
	var starting_text: String = text
	
	editing = false
	
	# Triger setters
	multiline = multiline
	
	self.text = starting_text


func _set(property: StringName, value: Variant):
	if property == &"text":
		if value == "":
			self.text = " "
			return true
		if not multiline and "\n" in value:
			self.text = value.replace("\n", " ")


func get_text_stored() -> String:
	if editing:
		return _last_text
	else:
		return text



func _on_code_edit_text_changed():
	#text = code_edit.text
	print(code_edit.get_caret_column())
	if not multiline and "\n" in code_edit.text:
		var caret_columns: Array[int] = []
		var line_lengths: Array[int] = []
		for line in code_edit.text.split("\n"):
			line_lengths.append(len(line))
		for caret in code_edit.get_caret_count():
			caret_columns.append(code_edit.get_caret_column(caret))
			for line in code_edit.get_caret_line(caret):
				caret_columns[-1] += line_lengths[line]
		
		#var new_text: String = ""
		#for char_i in len(code_edit.text):
			#var character: String = code_edit.text[char_i]
			#if character == "\n":
				#for caret in len(caret_columns):
					## caret at column 0 => no character before, char_i == 0 => first character
					#if caret_columns[caret] > char_i:
						#caret_columns[caret] -= 1
			#else:
				#new_text += character
		#
		#code_edit.text = new_text
		code_edit.text = code_edit.text.replace("\n", "")
		
		for caret in len(caret_columns):
			code_edit.set_caret_column(caret_columns[caret], true, caret)
	#pass


func _gui_input(event: InputEvent):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.double_click and event.pressed:
			editing = true


func _on_code_edit_text_set():
	pass
	#if not multiline and "\n" in code_edit.text:
		#code_edit.text = code_edit.text.replace("\n", " ")
	#editing = false
	#text = code_edit.text


func _on_code_edit_gui_input(event: InputEvent):
	if event is InputEventKey and event:
		if multiline and event.is_action(&"validate_input", true):
			code_edit.hide()


func _on_code_edit_focus_exited():
	code_edit.hide()


func _on_code_edit_visibility_changed():
	print(code_edit.visible)
	if !code_edit.visible:
		editing = false
