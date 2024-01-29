class_name DefaultNoteUIs
extends Object


static func _static_init() -> void:
	create_defaults()


static func create_defaults() -> void:
	NoteUI.new().set_type(Note).set_type_translation_key(
		"NOTE"
	).set_widget_edits([
		preload("res://src/gui/user_input/note_edition/widget_edits/title_widget_edit.tscn")
	]).auto_inherit().build()
	
	NoteUI.new().set_type(Calculus).set_type_translation_key(
		"CALCULUS"
	).set_display_widgets([
		preload("res://src/gui/displaying_notes/note_display/widgets/calculus_result.tscn"),
	]).auto_inherit().build()
	
	NoteUI.new().set_type(Variable).auto_inherit().set_type_translation_key(
		"VARIABLE"
	).set_display_widgets([
		preload("res://src/gui/displaying_notes/note_display/widgets/variable_name.tscn"),
	]).build()
	
	NoteUI.new().set_type(Task).auto_inherit().set_type_translation_key(
		"TASK"
	).set_display_widgets([
		preload("res://src/gui/displaying_notes/note_display/widgets/task_done.tscn"),
	]).build()
