extends Node


func _ready():
	randomize()
	
	# Static initialisations
	if ([
		Serializer,
		DefaultBuildingInfos,
		DefaultNoteUIs,
		DefaultCommands,
	]):
		pass
