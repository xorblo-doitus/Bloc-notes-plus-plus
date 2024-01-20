extends Node


func _ready():
	randomize()
	get_viewport().gui_embed_subwindows = false
	
	# Static initialisations
	if ([
		Serializer,
		DefaultBuildingInfos,
		DefaultNoteUIs,
		DefaultCommands,
	]):
		pass
