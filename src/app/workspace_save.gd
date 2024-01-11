class_name WorkspaceSave
extends RefCounted


## Stores informations about a workspace (Notes, sorting method...)


## Emitted when this workspace changes in any mean.
signal changed()


## The default value of [member note_list]
static var DEFAULT_NOTES: NoteList = NoteList.new([
	Note.new(TranslationServer.translate("EXEMPLE_NOTE_TITLE"), TranslationServer.translate("EXEMPLE_NOTE_DESCRIPTION")),
])


## The notes in this workspacce.
## [br][br][b]READONLY[/b]: Trying to modifying this attribute will only set it's
## [member NoteList.notes] to a [i]copy[/i] of the new one's [member NoteList.notes]
var note_list: NoteList = NoteList.new().mimic(DEFAULT_NOTES):
	set(new):
		note_list.mimic(new)



func _init() -> void:
	note_list.changed.connect(_on_note_list_changed)


func _on_note_list_changed(_new: Array[Note], _old: Array[Note]) -> void:
	changed.emit()
