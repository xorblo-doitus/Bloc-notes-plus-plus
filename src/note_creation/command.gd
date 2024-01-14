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
	
func check(L):
		if Parser.tokens[0] == "t" or Parser.tokens[0] == "task":
			names.append("t")
			names.append("task")
		elif Parser.tokens[0] == "c" or Parser.tokens[0] == "calc":
			names.append("c")
			names.append("calc")
		elif Parser.tokens[0] == "s" or Parser.tokens[0] == "store":
			names.append("s")
			names.append("store")
	