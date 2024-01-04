extends RefCounted

## Texte principal de la note et celui qui est affiché dans la liste de note
var title: String = ""
## Texte descriptif plus étoffé que le titre
var description: String = ""
## Des données, comme un texte ou un nombre...utiles pour la note
## [br] key: [String] value: [Variant]
var other_data: Dictionary = {}

var data: Dictionary = {}

var type: Object = Note
#func _init(text:="") -> void:
	#if text == "1" :
		#var json = JSON.new()
		#text = json.parse()

func _init(text):
	if len(text) != 0:
		parse(text)

func build():
	var new_note: Note = type.new()
	for key in data:
		new_note.set(key, data[key])
		

func parse(text: String):
	text = text.strip_edges()
	commande(text)
	var splited: Array[String] = text.split("\n", true, 1)
	if len(splited) == 2:
		title = splited[0]
		description = splited[1]

var prefixes = ["/", "\\"]

func commande(text: String):
	if text[0] in prefixes:
		if text[1] == "t" or text.substr(1, 4) == "task":
			type = Task
			return text.substr(2)
		elif text[1] == "c" or text.substr(1, 4) == "calc":
			type = Calculus
			return text.substr(2)
		elif text[1] == "s" or text.substr(1, 5) == "store":
			var res = Variable
			return text.substr(2)
