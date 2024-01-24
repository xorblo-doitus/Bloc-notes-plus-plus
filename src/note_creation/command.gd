class_name Command
extends RefCounted


static var all: Array[Command] = []


var names: Array[String] = []
var parameters: Array[String] = []
var callback: Callable


enum ParseError {
	OK,
	NOT_ENOUGH_ARGUMENT,
}


func set_names(new_names: Array[String]) -> Command:
	names = new_names
	return self


func set_parameters(new_parameters: Array[String]) -> Command:
	parameters = new_parameters
	return self


func build():
	Command.all.append(self)
	return self


func set_callback(function: Callable):
	callback = function
	return self
