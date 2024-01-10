class_name Command
extends RefCounted

var names: Array[String] = []
var argument = []

enum ParseError {
	OK,
	NOT_ENOUGH_ARGUMENT,
}

func set_names(new_names: Array[String]) -> Command:
	names = new_names
	return self

func is_text_me(text: String) -> bool:
	return text in names