extends RefCounted
class_name Note

## Texte principal de la note et celui qui est affiché dans la liste de note
var title: String = ""
## Texte descriptif plus étoffé que le titre
var description: String = ""
## Des données, comme un texte ou un nombre...utiles pour la note
## [br] key: [String] value: [Variant]
var other_data: Dictionary = {}

## Renvoie un texte pour pouvoir sauvegarder facilement dans un .txt
func serialize() -> String:
	var data: Dictionary = {
		"title": title, 
		"description": description, 
		"other data": other_data
		}
	return JSON.stringify(data, "\t")

## Désérialise une note sauvegardée en texte
static func deserialise(saved: String) -> Note:
	var new_note := Note.new()
	var json := JSON.new()
	
	json.parse(saved)
	
	return new_note
	
	
const attributes_to_serialize: Array[StringName] = [&"title", &"description", &"other_data"]
