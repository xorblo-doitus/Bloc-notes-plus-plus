extends Control


@export var notes_display: NoteListDisplay


var workspace: WorkspaceSave = WorkspaceSave.new():
	set(new):
		_disconnect_from_workspace(workspace)



func _ready():
	load_workspace()


func load_workspace() -> void:
	var loaded_workspace: Object = Saver.load_object_from_file(
		EasySettings.get_setting("save/path/latest_workspace")
	)
	
	if loaded_workspace is ErrorHelper:
		loaded_workspace.popup()
		return
	
	workspace = loaded_workspace
	
	_on_workspace_changed()


## Chainable
func _connect_to_workspace(target: WorkspaceSave) -> WorkspaceSave:
	target.changed.connect(_on_workspace_changed)
	
	return target


## Chainable
func _disconnect_from_workspace(target: WorkspaceSave) -> WorkspaceSave:
	target.changed.disconnect(_on_workspace_changed)
	
	return target


func _on_workspace_changed() -> void:
	notes_display.note_list = workspace.note_list
