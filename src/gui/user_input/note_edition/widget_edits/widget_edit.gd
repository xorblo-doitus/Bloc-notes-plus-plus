class_name WidgetEdit
extends Widget


var builder: Builder:
	set(new):
		Connection.destroy_all(_connections)
		builder = new
		if not is_node_ready():
			ready.connect(_connect_to.bind(builder), CONNECT_ONE_SHOT)
			return
		_connect_to(builder)


## Virtual method. Remember to call super() somewhere.
## Called automatically when [member builder] is set.
func _connect_to(_builder: Builder) -> void:
	pass


## Virtual method. Remember to call super() somewhere.
## Keys are attributes' names and values are their values.
## Not implemented this way, for now, all changes are instant.
func get_attributes_and_values() -> Dictionary:
	return {}
