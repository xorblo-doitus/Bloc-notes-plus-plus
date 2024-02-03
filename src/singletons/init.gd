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
	
	
	TranslationServer.set_locale.call_deferred(EasySettings.get_setting("internationalization/locale/current_locale"))
	
	#get_tree().node_added.connect(check_node)
#
#
#func check_node(node: Node) -> void:
	#print("check")
	#if node is PopupPanel:
		#pass
