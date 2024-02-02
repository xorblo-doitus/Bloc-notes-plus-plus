extends Control


## Please do NOT update this value after initialization.
@export var notes_display: NoteListDisplay


var workspace: WorkspaceSave = WorkspaceSave.new():
	set(new):
		if new == null:
			assert(false, "Trying to assign null to workspace wich is a non nullable attribute.")
			return
		_disconnect_from_workspace(workspace)
		_connect_to_workspace(new)
		workspace = new


@onready var fast_input: RichTextEdit = %FastInput


func _ready():
	notes_display.note_list.changed.connect(_on_note_list_changed)
	load_workspace()


#func _process(_d) -> void:
	#if Time.get_ticks_msec() % 10 == 0:
		#prints(
			#Time.get_ticks_msec(),
			#Variable.all_variables,
		#)
		#for ref in Variable.all_variables:
			#print(ref.get_ref(), " references: ", ref.get_ref().get_reference_count())


var first_load: bool = true
func load_workspace(path: String = "") -> void:
	if path:
		EasySettings.set_setting("save/path/latest_workspace", path)
	else:
		path = EasySettings.get_setting("save/path/latest_workspace")
	
	var loaded_workspace: Object = Saver.load_object_from_file(path)
	
	if loaded_workspace is ErrorHelper:
		if first_load and not loaded_workspace.godot_builtin_error == ERR_FILE_NOT_FOUND:
			loaded_workspace.set_description(
				tr(&"ERROR_WORKSPACE_LOAD_FAILED")
			).popup()
		
		first_load = false
		
		# Triger setter
		workspace = workspace
	else:
		workspace = loaded_workspace
	
	_on_note_list_changed(workspace.note_list.notes, [])


func save_workspace(path: String = "") -> void:
	if path:
		EasySettings.set_setting("save/path/latest_workspace", path)
	else:
		path = EasySettings.get_setting("save/path/latest_workspace")
	
	var error: ErrorHelper = Saver.save_object(workspace, path)
	
	if error:
		error.set_description(
			tr(&"ERROR_WORKSPACE_SAVE_FAILED")
		).popup()
		
		return


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
	
	print(new)
	
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


func _on_note_created(note: Note) -> void:
	workspace.note_list.notes.append(note)


func _on_fast_input_text_set(new: String) -> void:
	if new:
		_on_note_created(Parser.new().execute(new)["_current_builder"].build())
		fast_input.text = ""
		#fast_input._grab_focus.call_deferred()


func _on_load_pressed() -> void:
	if not GlobalFileDialog.request_dialog():
		return
	
	GlobalFileDialog.file_mode = FileDialog.FILE_MODE_OPEN_FILE
	GlobalFileDialog.filters = [
		"*.json, *.txt ; " + tr(&"WORKSPACE_SAVE"),
	]
	GlobalFileDialog.connect_while_in_use(
		Connection.new(GlobalFileDialog.file_selected, load_workspace)
	)
	GlobalFileDialog.show()


func _on_save_as_pressed() -> void:
	if not GlobalFileDialog.request_dialog():
		return
	
	GlobalFileDialog.file_mode = FileDialog.FILE_MODE_SAVE_FILE
	GlobalFileDialog.filters = [
		"*.json, *.txt ; " + tr(&"WORKSPACE_SAVE"),
	]
	GlobalFileDialog.current_path = EasySettings.get_setting("save/path/latest_workspace")
	GlobalFileDialog.connect_while_in_use(
		Connection.new(GlobalFileDialog.file_selected, save_workspace)
	)
	GlobalFileDialog.show()
