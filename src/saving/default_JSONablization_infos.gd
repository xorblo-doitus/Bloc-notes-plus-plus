class_name DefaultJSONablizationInfos
extends Object


static func create_defaults():
	var _note := JSONablizationInfo.new(Note, &"Note", [
		&"title",
		&"description",
		&"other_data",
		&"date",
	]).build()
	
	var _task := JSONablizationInfo.new(Task, &"Task", [
		&"done",
	]).auto_inherit().build()
	
	var _calculus := JSONablizationInfo.new(Calculus, &"Calculus", [
	]).auto_inherit().build()
	
	var _variable := JSONablizationInfo.new(Variable, &"Variable", [
		&"name",
	]).auto_inherit().build()
	
	JSONablizationInfo.new(NoteList, &"NoteList", [
		&"notes",
	]).build()
	
	JSONablizationInfo.new(NoteListDisplay, &"NoteListDisplay", [
		&"note_list",
	]).set_instantiating_function(NoteListDisplay.instantiate).build()
	
	JSONablizationInfo.new(WorkspaceSave, &"WorkspaceSave", [
		&"note_list",
	]).build()
	
	
	print_verbose("Loaded default JSONablizationInfos.")
