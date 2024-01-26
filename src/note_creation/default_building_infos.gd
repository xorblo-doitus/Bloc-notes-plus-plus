class_name DefaultBuildingInfos
extends Object


static func _static_init():
	create_defaults()


static func create_defaults():
	BuildingInfo.new(Note).set_type_translation_key(
		"NOTE"
	).set_widget_edits([
		preload("res://src/gui/user_input/note_edition/edition_widgets/title_widget_edit.tscn")
	]).auto_setup_from_JSONablization_info().build()
	
	BuildingInfo.new(Variable).set_type_translation_key(
		"VARIABLE"
	).auto_setup_from_JSONablization_info().build()
