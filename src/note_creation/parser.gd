class_name Parser
## Classe qui lit les commandes
extends RefCounted

## Classe qui lit les commandes
var tokens: Array[String] = []
var global_scope = {}
var prefixes = ["/", "\\"]
var quick_entry = NoteBuilder

func parse(text: String):
	text = text.strip_edges()
	var splited: Array[String] = text.split("\n", true, 1)
	if len(splited) == 2:
		NoteBuilder.title = splited[0]
		NoteBuilder.description = splited[1]
	global_scope[Variable.name] = Variable

func tokenise(text):
	var tokens: Array[String] = []
	var splited: Array[String] = text.split(" ", true, 1)
	var Command.names: Array[String] = []
	for elt in splited:
		tokens.append(elt)
		if tokens[0] in Command.names:
			return text in Command.names
		else:
			Command.check(tokens)