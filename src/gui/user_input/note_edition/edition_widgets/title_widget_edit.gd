extends EditionWidget


func _connect_to(_note: Note) -> void:
	super(_note)
	
	#_connections.append(Connection.new(_note.title_changed, update_value.unbind(2), true))
	#update_value()
