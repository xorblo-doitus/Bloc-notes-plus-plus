extends Control


## Please do not update this value after initialization
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
	notes_display.note_list.changed.connect(_on_note_list_changed)
	load_workspace()


func load_workspace() -> void:
	var loaded_workspace: Object = Saver.load_object_from_file(
		EasySettings.get_setting("save/path/latest_workspace")
	)
	
	if loaded_workspace is ErrorHelper:
		
		if not loaded_workspace.godot_builtin_error == ERR_FILE_NOT_FOUND:
			loaded_workspace.set_description(
				tr(&"ERROR_WORKSPACE_LOAD_FAILED")
			).popup()
		
		# Triger setter
		workspace = workspace
	else:
		workspace = loaded_workspace
	
	_on_note_list_changed(workspace.note_list.notes, [])


## Chainable
func _connect_to_workspace(target: WorkspaceSave) -> WorkspaceSave:
	target.note_list.changed.connect(_on_note_list_changed)
	
	return target


## Chainable
func _disconnect_from_workspace(target: WorkspaceSave) -> WorkspaceSave:
	if not target.note_list.changed.is_connected(_on_note_list_changed):
		return target
	
	target.note_list.changed.disconnect(_on_note_list_changed)
	
	return target


## Prevent infinite recursion of changed callbacks
var _can_change_notes: bool = true

func _on_note_list_changed(new: Array[Note], _old: Array[Note]) -> void:
	if not _can_change_notes:
		return
	
	_can_change_notes = false
		
	workspace.note_list.notes = new
	notes_display.note_list.notes = new
	
	_can_change_notes = true
	#_listening_to_notes_change = true

#func _on_workspace_changed() -> void:
	#if _listening_to_notes_change:
		#_listening_to_notes_change = false
		#
	#notes_display.note_list = workspace.note_list
	#
	#_listening_to_notes_change = true
#
#
#func _on_note_list_display_changed() -> void:
	#if _listening_to_notes_change:
		#_listening_to_notes_change = false
		#
	#notes_display.note_list = workspace.note_list
	#
	#_listening_to_notes_change = true
