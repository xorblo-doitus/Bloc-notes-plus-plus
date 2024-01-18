class_name Parser
extends RefCounted
## Classe qui lit les commandes

## Classe qui lit les commandes
static var tokens: Array[String] = []
static var global_scope := {}
static var prefixes = ["/", "\\"]
static var quick_entry = NoteBuilder

static func parse():
	global_scope.clear()
	global_scope["_curent_note_builder"] = NoteBuilder.new()
	
	#if len(splited) == 2:
		#NoteBuilder.title = splited[0]
		#NoteBuilder.description = splited[1]
	#for token in tokens:
	while not tokens.is_empty():
		var token: String = tokens.pop_front()
		for prefix in prefixes:
			if token.begins_with(prefix):
				var command_name: String = token.trim_prefix(prefix)
				for command in Command.all:
					if command_name in command.names:
						var arguments = []
						arguments.append(token.pop_front())
						command.callback.call(arguments, global_scope)
				break
			

static func tokenise(text):
	var tokens: Array[String] = []
	var splited: Array[String] = text.split(" ", true, 1)
	for elt in splited:
		tokens.append(elt)
		if tokens[0] in Command.names:
			return text in Command.names
		else:
			Command.check(tokens)