extends Node


func _ready():
	randomize()
	
	if not DirAccess.dir_exists_absolute(EasySettings.get_setting("save/path/workspaces")):
		DirAccess.make_dir_recursive_absolute(EasySettings.get_setting("save/path/workspaces"))
	
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
