class_name WorkspaceSave
extends RefCounted


## Stores informations about a workspace (Notes, sorting method...)


## Emitted when this workspace changes in any mean.
#signal changed()


## The default value of [member note_list]
static var DEFAULT_NOTES: NoteList = NoteList.new([
	Note.new(TranslationServer.translate("EXEMPLE_NOTE_TITLE"), TranslationServer.translate("EXEMPLE_NOTE_DESCRIPTION")),
]) if not OS.is_debug_build() else NoteList.new([
	Note.new(TranslationServer.translate("EXEMPLE_NOTE_TITLE"), TranslationServer.translate("EXEMPLE_NOTE_DESCRIPTION")),
	Task.new("Debugging task."),
	Task.new("I am done.").set_done(true),
	Variable.new("100*3").set_name("ma_variable"),
	Calculus.new("1.0/2+3+ma_variable"),
])


## The notes in this workspacce.
## [br][br][b]READONLY[/b]: Trying to modifying this attribute will only set it's
## [member NoteList.notes] to a [i]copy[/i] of the new one's [member NoteList.notes]
var note_list: NoteList = NoteList.new().mimic(DEFAULT_NOTES):
	set(new):
		note_list.mimic(new)
