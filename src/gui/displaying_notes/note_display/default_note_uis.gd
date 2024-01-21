class_name DefaultNoteUIs
extends Object


static func _static_init() -> void:
	create_defaults()


static func create_defaults() -> void:
	var _calculus := NoteUI.new().set_type(Calculus).set_display_widgets([
		preload("res://src/gui/displaying_notes/note_display/widgets/calculus_result.tscn"),
	]).build()
	NoteUI.new().set_type(Variable).set_display_widgets([
		preload("res://src/gui/displaying_notes/note_display/widgets/variable_name.tscn"),
	]).set_inherit(_calculus).build()
