class_name NoteList
extends RefCounted


## An array of [Note]s.
##
## Holds multiple ordered [Note]s, and has helpful features, like [signal changed].


## Emitted when notes are not the same anymore.
signal changed(new: Array[NoteList], old: Array[NoteList])


## Stores references to all [NoteList]s created.
static var all: Array[NoteList] = []

## The notes of this list, you can edit this.
var notes: Array[Note] = []

## The state of this note last frame.
@warning_ignore("unused_private_class_variable")
var _last_notes: Array[Note] = []


func _init(_notes: Array[Note] = []):
	if _notes:
		notes = _notes
	NoteList.all.push_back(self)


func _to_string() -> String:
	return "NoteList (" + str(len(notes)) + "): " + str(notes)


## Returns note that are going to be displayed.
## Includes fake notes used for arranging purpose while dragging.
func get_notes_to_display() -> Array[Note]:
	return notes


func mimic(other: NoteList) -> void:
	notes = other.notes.duplicate()


func _is_equal(other: Variant) -> bool:
	if other is Array:
		if len(other) != len(notes):
			return false
		
		for i in len(other):
			var element: Variant = other[i]
			if element is Note:
				if not notes[i]._is_equal(element):
					return false
			else:
				return false
		return true
	
	if other is NoteList:
		if len(other.notes) != len(notes):
			return false
		
		for i in len(other.notes):
			var others_note: Variant = other.notes[i]
			if not notes[i]._is_equal(others_note):
				return false
		return true
	
	return false
