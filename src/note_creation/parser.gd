class_name Parser
extends RefCounted
## Classe qui lit les commandes

## Classe qui lit les commandes
static var tokens: Array[String] = []
static var global_scope := {}
static var prefixes = ["/", "\\"]
static var quick_entry = Builder


static func _static_init() -> void:
	Command.new().set_names(
		["flush_unused_tokens"]
	).set_callback(
		Parser.flush_unused_tokens
	).build()


static func flush_unused_tokens(_argument: Array[String], context: Dictionary) -> void:
	var text: String = " ".join(context["_unused_tokens"]).strip_edges()
	var builder: Builder = context["_current_builder"]
	if builder.attributes.get("title"):
		builder.set_attribute("description", builder.attributes.get("description", "") + text)
	else:
		builder.set_attribute("title", text)


static func parse():
	reset_global_scope()
	print(tokens)
	#if len(splited) == 2:
		#Builder.title = splited[0]
		#Builder.description = splited[1]
	#for token in tokens:
	while not tokens.is_empty():
		var token: String = tokens.pop_front()
		var was_a_command: bool = false
		
		for prefix in prefixes:
			if token.begins_with(prefix):
				var command_name: String = token.trim_prefix(prefix)
				for command in Command.all:
					if command_name in command.names:
						var arguments: Array[String] = []
						for __ in len(command.parameters):
							arguments.append(tokens.pop_front())
						command.callback.call(arguments, global_scope)
						
						was_a_command = true
						break
				break
		if not was_a_command:
			global_scope["_unused_tokens"].append(token)


static func tokenise(text: String) -> Array[String]:
	tokens = []
	
	text = text.replace("\n", "\n " + prefixes[0] + "flush_unused_tokens ")
	
	var splited: PackedStringArray = text.split(" ", true)
	
	tokens.append_array(splited)
	tokens.append(prefixes[0] + "flush_unused_tokens")
	
	return tokens


static func reset_global_scope():
	global_scope.clear()
	
	global_scope["_current_builder"] = Builder.new()
	global_scope["_unused_tokens"] = []


static func execute(text: String):
	tokenise(text)
	parse()
	return global_scope.duplicate()
