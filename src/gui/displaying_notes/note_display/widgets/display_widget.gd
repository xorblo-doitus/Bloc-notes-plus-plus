class_name DisplayWidget
extends Widget


## If true, this widget is placed before the title
@export var before: bool = false

var note: Note:
	set(new):
		Connection.destroy_all(_connections)
		note = new
		_connect_to(note)


## Virtual method. Remember to call super() somewhere.
## Called automatically when [member note] is set.
func _connect_to(_note: Note) -> void:
	pass

