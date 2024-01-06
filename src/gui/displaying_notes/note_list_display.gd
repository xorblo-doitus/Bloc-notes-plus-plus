class_name NoteListDisplay
extends PanelContainer

@onready var notes_container: VBoxContainer = %NotesContainer

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
static var _default_scene: PackedScene = load("res://src/gui/displaying_notes/note_list_display.tscn")

## Create a new instance by loading default scene for this class.
static func instantiate() -> NoteListDisplay:
	return _default_scene.instantiate()


func _init() -> void:
	note_list.changed.connect(build_note_displays.unbind(2))


func build_note_displays() -> void:
	# Unlink displays wich displays a note that don't belong to self
	for display in _note_displays:
		if display.connected_to and not display.connected_to in notes:
			display.connected_to.unapply_from_display(display)
	
	## A Queue (fr: Une file)
	var new_displays: Array[NoteDisplay] = []
	
	for note in notes:
		new_displays.append(_pop_note_display_for(note))
	
	while _note_displays:
		_note_displays.pop_back().queue_free()
	
	_note_displays.append_array(new_displays)
	_reorder_note_displays()


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
		if display.connected_to == note:
			_note_displays.remove_at(display_i)
			return display
	
	var new: NoteDisplay = NoteDisplay.instantiate()
	note.apply_to_display(new)
	return new
