extends Widget


static var equal_string = " ="


@onready var result: Label = %Result


func _connect_to(_note: Note) -> void:
	super(_note)
	
	_note.title_changed.connect(update_value.unbind(2))
	update_value()


func update_value() -> void:
	result.text = str(note.get_value()) + equal_string
