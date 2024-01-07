class_name WorkspaceSave
extends RefCounted


## Stores informations about a workspace (Notes, sorting method...)


## The default value of [member note_list]
static var DEFAULT_NOTES: NoteList = NoteList.new([
	Note.new("Exemple de note.", "Ceci est une description."),
])


## The notes in this workspacce.
## [br][br][b]READONLY[/b]: Trying to modifying this attribute will only set it's
## [member NoteList.notes] to a [i]copy[/i] of the new one's [member NoteList.notes]
var note_list: NoteList = NoteList.new().mimic(DEFAULT_NOTES):
	set(new):
		note_list.mimic(new)


func _init() -> void:
	pass
