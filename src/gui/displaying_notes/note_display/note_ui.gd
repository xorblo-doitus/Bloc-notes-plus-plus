class_name NoteUI
extends RefCounted


## the type of note to wich this UI applies.
var type: Object
## A list of Widget PackedScenes
var display_widgets: Array[PackedScene] = []
var widget_edits: Array[PackedScene] = []
## From wich NoteUI this one inherit it's informations
var inherit: NoteUI


func set_type(_type: Object) -> NoteUI:
	type = _type
	return self


func set_display_widgets(_display_widgets: Array[PackedScene]) -> NoteUI:
	display_widgets = _display_widgets
	return self


func set_widget_edits(_display_widgets: Array[PackedScene]) -> NoteUI:
	display_widgets = _display_widgets
	return self


func set_inherit(_inherit: NoteUI) -> NoteUI:
	inherit = _inherit
	return self


func build() -> NoteUI:
	NoteDisplay.note_UIs[type] = self
	return self


func get_heritage() -> Array[NoteUI]:
	var result: Array[NoteUI] = [self]
	
	while result[-1].inherit:
		result.append(result[-1].inherit)
	
	return result
