extends Control


@export var notes_display: NoteListDisplay


var workspace: WorkspaceSave = WorkspaceSave.new():
	set(new):
		if new == null:
			assert(false, "Trying to assign null to workspace wich is a non nullable attribute.")
			return
		_disconnect_from_workspace(workspace)
		_connect_to_workspace(new)
		workspace = new



func _ready():
	load_workspace()


func load_workspace() -> void:
	var loaded_workspace: Object = Saver.load_object_from_file(
		EasySettings.get_setting("save/path/latest_workspace")
	)
	
	if loaded_workspace is ErrorHelper:
		if not loaded_workspace.godot_builtin_error == ERR_FILE_NOT_FOUND:
			loaded_workspace.popup()
		
		# Triger setter
		workspace = workspace
	else:
		workspace = loaded_workspace
	
	_on_workspace_changed()


## Chainable
func _connect_to_workspace(target: WorkspaceSave) -> WorkspaceSave:
	target.changed.connect(_on_workspace_changed)
	
	return target


## Chainable
func _disconnect_from_workspace(target: WorkspaceSave) -> WorkspaceSave:
	if not target.changed.is_connected(_on_workspace_changed):
		return target
	
	target.changed.disconnect(_on_workspace_changed)
	
	return target


func _on_workspace_changed() -> void:
	notes_display.note_list = workspace.note_list
