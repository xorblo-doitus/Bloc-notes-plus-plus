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
	]).set_inherit(_note).build()
	
	var _calculus := JSONablizationInfo.new(Calculus, &"Calculus", [
	]).set_inherit(_note).build()
	
	var _variable := JSONablizationInfo.new(Variable, &"Variable", [
		&"name",
	]).set_inherit(_calculus).build()
