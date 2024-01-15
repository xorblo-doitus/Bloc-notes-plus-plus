class_name Note
extends RefCounted


signal title_changed(new: String, old: String)
signal description_changed(new: String, old: String)


## Texte principal de la note et celui qui est affiché dans la liste de note
var title: String = "":
	set(new):
		if new == title:
			return
		
		var old: String = title
		title = new
		title_changed.emit(title, old)
func set_title(new: String) -> Note:
	title = new
	return self

## Texte descriptif plus étoffé que le titre
var description: String = "":
	set(new):
		if new == description:
			return
		var old: String = description
		description = new
		description_changed.emit(description, old)

## Des données (comme un texte, un nombre etc...) utiles pour la note
## [br] key: [String] value: [Variant]
var other_data: Dictionary = {}


func _init(_title: String = "", _description: = ""):
	title = _title
	description = _description


#var _connected_displays: Array[NoteDisplay] = []



func _to_string():
	return "Note: \"" + title + "\""


func _is_equal(other: Variant) -> bool:
	return (
		other is Note
		and other.get_script() == get_script()
		and other.title == title
		and other.description == description
	)
