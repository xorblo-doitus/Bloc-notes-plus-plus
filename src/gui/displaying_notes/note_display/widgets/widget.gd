class_name Widget
extends PanelContainer


var _connections: Array[Connection] = []
var note: Note:
	set(new):
		Connection.destroy_all(_connections)
		note = new
		_connect_to(note)


## Virtual method. Remember to call super() somewhere.
## Called automatically when [member note] is set.
func _connect_to(_note: Note) -> void:
	pass
