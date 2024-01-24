class_name DefaultCommands
extends Object


static func _static_init():
	create_defaults()


static func create_defaults():
	Command.new().set_names(
		["store", "s"]
	).set_callback(
		DefaultCommands.store_callback
	).build()

static func store_callback(argument: Array[String], context: Dictionary):
	context["_current_builder"].type = Variable
	context["_current_builder"].set_attribute("name", argument[0])
