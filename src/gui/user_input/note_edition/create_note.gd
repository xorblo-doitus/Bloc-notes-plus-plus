extends Button


signal note_created(note: Note)


var _connections: Dictionary = {}

func _on_pressed() -> void:
	var gui = BuilderGUI.request_edition(true)
	
	if gui == null:
		return
	
	gui.builder = Builder.new()
	
	var current_connections: Array[Connection] = []
	current_connections.append(Connection.new(
		gui.confirmed,
		_on_creation_confirmed.bind(gui),
		true,
		CONNECT_ONE_SHOT
	))
	current_connections.append(Connection.new(
		gui.canceled,
		_on_canceled.bind(gui),
		true,
		CONNECT_ONE_SHOT
	))
	_connections[gui] = current_connections
	
	get_tree().root.add_child(gui)
	gui.show()


func _on_creation_confirmed(gui: BuilderGUI) -> void:
	note_created.emit(gui.builder.build())
	Connection.destroy_all(_connections[gui])


func _on_canceled(gui: BuilderGUI) -> void:
	Connection.destroy_all(_connections[gui])
