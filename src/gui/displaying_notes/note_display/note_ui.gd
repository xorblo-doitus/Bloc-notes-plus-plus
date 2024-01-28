class_name NoteUI
extends RefCounted



## Static variable storing informations about how to create notes.
## Keys are the type as [Script]. See also [member all_from_string].
static var all: Dictionary = {}


## the type of note to wich this UI applies.
var type: Object
## The translation key of the type.
var type_translation_key: String
## A list of [DisplayWidget] as [PackedScene]
var display_widgets: Array[PackedScene] = []
## A list of [WidgetEdit] as [PackedScene]
var widget_edits: Array[PackedScene] = []
## From wich NoteUI this one inherit it's informations
var inherit: NoteUI


func set_type(_type: Object) -> NoteUI:
	type = _type
	return self


func set_display_widgets(_display_widgets: Array[PackedScene]) -> NoteUI:
	display_widgets = _display_widgets
	return self


func set_widget_edits(_widget_edits: Array[PackedScene]) -> NoteUI:
	widget_edits = _widget_edits
	return self


func set_inherit(_inherit: NoteUI) -> NoteUI:
	inherit = _inherit
	return self


func auto_inherit() -> NoteUI:
	inherit = ST.dic_get_from_type(NoteUI.all, type)
	return self


func set_type_translation_key(_type_translation_key: String) -> NoteUI:
	type_translation_key = _type_translation_key
	return self


## Create this NoteUI.
func build() -> NoteUI:
	NoteUI.all[type] = self
	return self


static func get_most_precise(for_type: Object) -> NoteUI:
	var result: NoteUI = ST.dic_get_from_type(
		NoteUI.all,
		for_type
	)
	
	if result == null:
		assert(false, "No NoteUI for " + str(for_type))
	
	return result


func get_heritage() -> Array[NoteUI]:
	var result: Array[NoteUI] = [self]
	
	while result[-1].inherit:
		result.append(result[-1].inherit)
	
	return result
