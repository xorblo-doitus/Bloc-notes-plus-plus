class_name NoteListDisplay
extends PanelContainer

@onready var notes_container: VBoxContainer = %NotesContainer
@onready var progress_bar: ProgressBar = %ProgressBar

## The notes displayed.
## [br][br][b]READONLY[/b]: Trying to modifying this attribute will only set it's
## [member NoteList.notes] to a [i]copy[/i] of the new one's [member NoteList.notes]
var note_list: NoteList = NoteList.new():
	set(new):
		note_list.mimic(new)

## Shortcut for [member note_list].notes, see [member NoteList.notes]
var notes: Array[Note]:
	set(new):
		note_list.notes = new.duplicate()
	get:
		return note_list.notes

## Stores displays used by this list displayer.
var _note_displays: Array[NoteDisplay] = []


## A reference to the default packed scene associated with this class
static var _default_scene: PackedScene:
	get:
		if _default_scene == null:
			_default_scene = load("res://src/gui/displaying_notes/note_list_display.tscn")
		return _default_scene

## Create a new instance by loading default scene for this class.
static func instantiate() -> NoteListDisplay:
	return _default_scene.instantiate()


func _init() -> void:
	note_list.changed.connect(build_note_displays.unbind(2))


func _enter_tree() -> void:
	build_note_displays()


func build_note_displays() -> void:
	if not is_inside_tree():
		return
	# Unlink displays wich displays a note that don't belong to self
	for display in _note_displays:
		if display._displaying and not display._displaying in notes:
			display.undisplay()
	
	## A Queue (fr: Une file)
	var new_displays: Array[NoteDisplay] = []
	
	for note in notes:
		new_displays.append(_pop_note_display_for(note))
	
	while _note_displays:
		_note_displays.pop_back().queue_free()
	
	_note_displays.append_array(new_displays)
	_reorder_note_displays()
	update_completion_percent()


var _task_connections: Array[Connection] = []

func update_completion_percent() -> void:
	if not is_node_ready():
		ready.connect(update_completion_percent, CONNECT_ONE_SHOT)
		return
	
	Connection.destroy_all(_task_connections)
	
	var tasks: int = 0
	var done: int = 0
	
	for note in notes:
		if note is Task:
			tasks += 1
			
			_task_connections.append(Connection.new(
				note.done_toggled,
				update_completion_percent.unbind(1),
				true
			))
			
			if note.done:
				done += 1
			
	
	if tasks == 0:
		progress_bar.hide()
		return
	
	progress_bar.show()
	
	progress_bar.max_value = tasks
	progress_bar.value = done


## Unparent all displays and reparent them in the right order
func _reorder_note_displays() -> void:
	for display in _note_displays:
		var parent: Node = display.get_parent()
		if parent:
			parent.remove_child(display)
		
		notes_container.add_child(display)


## Sees if there is already a display available for this note or
## create a new one else.
func _pop_note_display_for(note: Note) -> NoteDisplay:
	for display_i in len(_note_displays):
		var display: NoteDisplay = _note_displays[display_i]
		if display._displaying == note:
			_note_displays.remove_at(display_i)
			return display
	
	return create_note_display(note)


func create_note_display(note: Note = null) -> NoteDisplay:
	var new: NoteDisplay = NoteDisplay.instantiate()
	_note_display_setup(new)
	
	
	if note:
		new.display(note)
	return new


func _note_display_setup(note_display: NoteDisplay) -> void:
	if not note_display.is_node_ready():
		_note_display_setup.call_deferred(note_display)
		return
	note_display.request_remove.connect(remove.bind(note_display))
	note_display.grip_component.element_dropped.connect(handle_drop.bind(note_display))
	note_display.grip_component.left.connect(remove.bind(note_display))


func handle_drop(element: Control, side: GripDropArea.Side, on: NoteDisplay) -> void:
	if element is NoteDisplay:
		var index: int = note_list.notes.find(on._displaying)
		if side == GripDropArea.Side.DOWN:
			index += 1
		note_list.notes.insert(index, element._displaying)
		return
	
	assert(false, "Unknown drop behavior for " + str(element))


func remove(note_display: NoteDisplay) -> void:
	note_list.notes.erase(note_display._displaying)


func _is_equal(other: Variant) -> bool:
	if other is NoteListDisplay:
		return note_list._is_equal(other.note_list)
	
	return false
