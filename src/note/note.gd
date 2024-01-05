extends RefCounted
class_name Note

## Texte principal de la note et celui qui est affiché dans la liste de note
var title: String = "":
	set(new):
		title = new
		for display in _connected_displays:
			display.title = title
func set_title(new: String) -> Note:
	title = new
	return self
## Texte descriptif plus étoffé que le titre
var description: String = "":
	set(new):
		description = new
		for display in _connected_displays:
			display.description = description
## Des données, comme un texte ou un nombre...utiles pour la note
## [br] key: [String] value: [Variant]
var other_data: Dictionary = {}


func _init(_title: String = "", _description: = ""):
	title = _title
	description = _description


var _connected_displays: Array[NoteDisplay] = []
func apply_to_display(display: NoteDisplay) -> void:
	display.title = title
	display.description = description
	
	_connected_displays.append(display)
	
	display._connections.append(Connection.new(display.title_changed, set_title.unbind(1), true))
	display.connected_to = self


func unapply_from_display(display: NoteDisplay) -> void:
	_connected_displays.erase(display)
	
	while display._connections:
		display._connections.pop_back().destroy()
	display.connected_to = null


func _to_string():
	return "Note: \"" + title + "\""


func _is_equal(other: Variant) -> bool:
	return (
		other is Note
		and other.get_script() == get_script()
		and other.title == title
		and other.description == description
	)
