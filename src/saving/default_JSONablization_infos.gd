extends Object
class_name DefaultJSONablizationInfos


static func create_defaults():
	var _note := JSONablizationInfo.new(Note, &"Note", [
		&"title",
		&"description",
		&"other_data",
	]).build()
	
	var _task := JSONablizationInfo.new(Task, &"Task", [
		&"time_limit",
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
	
	
	print_verbose("Loaded default JSONablizationInfos.")
