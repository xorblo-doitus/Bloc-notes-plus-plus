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
	
	BuilderGUI._fetch_types()
