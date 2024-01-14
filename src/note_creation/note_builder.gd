class_name NoteBuilder
##Classe qui crée les notes
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
var time_limit: int = 0
#func _init(text:="") -> void:
	#if text == "1" :
		#var json = JSON.new()
		#text = json.parse()

func _init(text):
	if len(text) != 0:
		Parser.parse(text)
	Parser.tokenise(text)
	if Command.names[0] == "t":
		type = Task
	elif Command.names[0] == "c":
		type = Calculus
	elif Command.names[0] == "s":
		type = Variable

func build():
	var new_note: Note = type.new()
	for key in data:
		new_note.set(key, data[key])

