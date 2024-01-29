extends DisplayWidget


@onready var done_check_box: CheckBox = %DoneCheckBox


func _connect_to(_note: Note) -> void:
	super(_note)
	
	_connections.append(Connection.new(_note.done_toggled, set_done_status, true))
	set_done_status()


func set_done_status(status: bool = note.done) -> void:
	done_check_box.button_pressed = status
