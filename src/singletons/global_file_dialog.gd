extends FileDialog


var in_use: bool = false:
	set(new):
		in_use = new
		if not in_use:
			Connection.destroy_all(_connections)


func _ready() -> void:
	queue_free()
	size = 0.5 * DisplayServer.screen_get_size()


func request_dialog() -> bool:
	if in_use:
		return false
	
	in_use = true
	return true


var _connections: Array[Connection] = []

## [param connection] must not be already connected.
func connect_while_in_use(connection: Connection) -> void:
	connection.create()
	_connections.append(connection)


func _on_visibility_changed() -> void:
	if not visible:
		in_use = false
