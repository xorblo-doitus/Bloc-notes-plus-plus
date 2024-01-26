#@tool
class_name RichTextEdit
extends MarginContainer


signal text_changed(new: String, old: String)
signal text_set(new: String)


## If true, text will be submitted only when enter is pressed while shift too.
## This helps to edit multiline texts.
## This will also enable other features.
@export var multiline: bool = false:
	set(new):
		multiline = new
		if code_edit:
			code_edit.gutters_draw_line_numbers = new
		#fit_content = not new
		#%CodeEdit.scroll_fit_content_height = not new
		#code_edit.fit
## If true, text will be submitted only when enter is pressed while shift too.
## This helps to edit multiline texts.
#@export var shift_to_validate: bool = true
@export var auto_width: bool = false
@export var max_width: float = -1
@export var text: String:
	set(new):
		if new == text:
			return
		
		if not is_node_ready():
			ready.connect(set.bind(&"text", new), CONNECT_ONE_SHOT)
			return
		
		var old: String = text
		text = new
		rich_text_label.text = " " + text
		
		if code_edit.text != text:
			code_edit.text = text
		
		update_width()
		
		text_changed.emit(new, old)

var editing: bool = false:
	set(new):
		if new == editing:
			return
		editing = new
		if new:
			setup_editing()
		else:
			unsetup_editing()


#var _last_text: String = text


@onready var code_edit: CodeEdit = %CodeEdit
@onready var rich_text_label: RichTextLabel = %RichTextLabel


## A reference to the default packed scene associated with this class
static var _default_scene: PackedScene:
	get:
		if _default_scene == null:
			_default_scene = FilePathes.get_resource(&"rich_text_edit")
		return _default_scene

## Create a new instance by loading default scene for this class.
static func instantiate() -> RichTextEdit:
	return _default_scene.instantiate()


func _ready():
	#if text == "":
		#text = " "
	#var starting_text: String = text
	
	unsetup_editing()
	
	# Triger setters
	multiline = multiline
	
	# code_edit.get_h_scroll_bar().size.x = 0
	# code_edit.get_v_scroll_bar().size.x = 0
	
	#update_width()
	
	#self.text = starting_text


func _set(property: StringName, value: Variant):
	if property == &"text":
		if value == "":
			self.text = " "
			return true
		if not multiline and "\n" in value:
			self.text = value.replace("\n", " ")


func _on_code_edit_text_changed():
	if not editing:
		return
	
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
	
	text = code_edit.text


var _line := TextLine.new()

func update_width() -> void:
	if auto_width:
		# good character to test auto_width : 𒀱
		_line.clear()
		var sizer = get_current_sizer()
		_line.add_string(sizer.text + "_", sizer.get_theme_font("font"), sizer.get_theme_font_size("font_size"))
		
		var true_length: float = ceil(_line.get_line_width())
		_line.clear()
		_line.add_string(sizer.text + "___", sizer.get_theme_font("font"), sizer.get_theme_font_size("font_size"))
		
		custom_minimum_size.x = min(true_length, INF if max_width == -1 else max_width)
		set_deferred("custom_minimum_size", custom_minimum_size)
		#print(custom_minimum_size.x)
		#print(true_length)
		#print(_line.get_line_width())
		#print(-_line.get_line_width() + true_length)
		add_theme_constant_override("margin_right", true_length - ceil(_line.get_line_width()))
		#print(line.get_line_width())
		#print(custom_minimum_size.x)
		#print(size.x)
		#print(line.get_size())

#func _gui_input(event: InputEvent):
	#if event is InputEventMouseButton:
		#if event.button_index == MOUSE_BUTTON_LEFT and event.double_click and event.pressed:
			#editing = true


#func _on_code_edit_text_set():
	#pass
	#if not multiline and "\n" in code_edit.text:
		#code_edit.text = code_edit.text.replace("\n", " ")
	#editing = false
	#text = code_edit.text


func _on_code_edit_gui_input(event: InputEvent):
	if event is InputEventKey and event:
		var starting_shift_state = event.shift_pressed
		if not multiline:
			event.shift_pressed = true
		
		if event.is_action(&"validate_input", true):
			editing = false
			get_viewport().set_input_as_handled()
		
		event.shift_pressed = starting_shift_state



func _on_code_edit_focus_entered() -> void:
	editing = true


func _on_code_edit_focus_exited():
	editing = false


#var _text_at_edition: String =
func setup_editing() -> void:
	code_edit.grab_focus.call_deferred()
	if multiline:
		code_edit.gutters_draw_line_numbers = true
	code_edit.modulate = Color.WHITE
	rich_text_label.modulate = Color.TRANSPARENT
	#code_edit.text = text
	#visible_characters = 0

func unsetup_editing() -> void:
	text = code_edit.text
	code_edit.gutters_draw_line_numbers = false
	code_edit.modulate = Color.TRANSPARENT
	rich_text_label.modulate = Color.WHITE
	text_set.emit(code_edit.text)
	#code_edit.text = " "
	#if text != _last_text:
		#text_set.emit(text, _last_text)
	#visible_characters = -1


func get_current_sizer():
	if editing:
		return code_edit
	
	return rich_text_label


#func _on_code_edit_visibility_changed():
	#if !code_edit.visible:
		#editing = false


#func _on_code_edit_text_set() -> void:
	#text_set.emit(code_edit.text)
