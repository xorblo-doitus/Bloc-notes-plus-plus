extends RefCounted
class_name Note

## Texte principal de la note et celui qui est affiché dans la liste de note
var title: String = ""
## Texte descriptif plus étoffé que le titre
var description: String = ""
## Des données, comme un texte ou un nombre...utiles pour la note
## [br] key: [String] value: [Variant]
var other_data: Dictionary = {}


func _init():
	pass # Replace with function body


func _to_string():
	return "Note: \"" + title + "\""


func _is_equal(other: Variant) -> bool:
	return (
		other is Note
		and other.get_script() == get_script()
		and other.title == title
		and other.description == description
	)
