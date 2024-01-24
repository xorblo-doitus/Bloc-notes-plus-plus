class_name Parser
extends RefCounted
## Classe qui lit les commandes

## Classe qui lit les commandes
static var tokens: Array[String] = []
static var global_scope := {}
static var prefixes = ["/", "\\"]
static var quick_entry = Builder

static func parse():
	reset_global_scope()
	
	#if len(splited) == 2:
		#Builder.title = splited[0]
		#Builder.description = splited[1]
	#for token in tokens:
	while not tokens.is_empty():
		var token: String = tokens.pop_front()
		for prefix in prefixes:
			if token.begins_with(prefix):
				var command_name: String = token.trim_prefix(prefix)
				for command in Command.all:
					if command_name in command.names:
						var arguments: Array[String] = []
						for __ in len(command.parameters):
							arguments.append(tokens.pop_front())
						command.callback.call(arguments, global_scope)
				break
			

static func tokenise(text) -> Array[String]:
	tokens = []
	var splited: PackedStringArray = text.split(" ", true, 1)
	
	tokens.append_array(splited)
	
	return tokens


static func reset_global_scope():
	global_scope.clear()
	
	global_scope["_current_builder"] = Builder.new()

static func execute(text: String):
	tokenise(text)
	parse()
	return global_scope.duplicate()