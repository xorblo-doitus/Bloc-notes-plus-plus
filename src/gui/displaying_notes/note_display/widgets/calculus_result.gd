class_name WidgetCalculusResult
extends Widget


static var equal_string = " ="


@onready var result: Label = %Result


func _connect_to(_note: Note) -> void:
	super(_note)
	
	_connections.append(Connection.new(_note.title_changed, update_value.unbind(2), true))
	update_value()


func update_value() -> void:
	result.text = str(note.get_value()) + WidgetCalculusResult.equal_string
