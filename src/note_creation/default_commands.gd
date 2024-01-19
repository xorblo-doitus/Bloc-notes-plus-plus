class_name DefaultCommands
extends Object


static func _static_init():
	create_defaults()


static func create_defaults():
	Command.new().set_names(["store", "s"]).set_callback(store_callback)

static func store_callback(argument: Array[String], context: Dictionary):
	context["current_note_builder"].type = Variable
	argument[0]