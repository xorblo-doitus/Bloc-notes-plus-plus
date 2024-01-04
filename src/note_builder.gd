extends RefCounted

## Texte principal de la note et celui qui est affiché dans la liste de note
var title: String = ""
## Texte descriptif plus étoffé que le titre
var description: String = ""
## Des données, comme un texte ou un nombre...utiles pour la note
## [br] key: [String] value: [Variant]
var other_data: Dictionary = {}

var data: Dictionary = {}
var note_number = 0
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
	note_number += 1
	if progression == 100:
		progression = 0

var prefixes = ["/", "\\"]
var finished_task = 0

func commande(text: String):
	if text[0] in prefixes:
		if text[1] == "t" or text.substr(1, 2) == "ta" or text.substr(1, 3) == "tas" or text.substr(1, 4) == "task":
			type = Task
			return text.substr(2)
		elif text[1] == "c" or text.substr(1, 2) == "ca" or text.substr(1, 3) == "cal" or text.substr(1, 4) == "calc":
			type = Calculus
			return text.substr(2)
		elif text[1] == "s" or text.substr(1, 2) == "st"  or text.substr(1, 3) == "sto"  or text.substr(1, 4) == "stor"  or text.substr(1, 5) == "store":
			var res = Variable
			return text.substr(2)

var progression = note_number*100/finished_task
