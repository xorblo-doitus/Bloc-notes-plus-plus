class_name NoteDisplay
extends PanelContainer


## Emitted when delete button is pressed, etc...
signal request_remove()


## The child index at wich widget with [member Widget.before] = [code]true[/code]
## will be inserted.
const FRONT_WIDGET_INDEX = 1


#static var note_UIs: Dictionary = {}


@warning_ignore("unused_private_class_variable")
var _connections: Array[Connection]
var _displaying: Note


@onready var title: RichTextEdit = %Title
@onready var grip_component: GripComponent = %GripComponent
@onready var display_widgets: HBoxContainer = %Widgets


## A reference to the default packed scene associated with this class
static var _default_scene: PackedScene:
	get:
		if _default_scene == null:
			_default_scene = load("res://src/gui/displaying_notes/note_display/note_display.tscn")
		return _default_scene

## Create a new instance by loading default scene for this class.
static func instantiate() -> NoteDisplay:
	return _default_scene.instantiate()


var _display_widgets: Array[DisplayWidget] = []

func display(note: Note) -> void:
	if not is_node_ready():
		ready.connect(display.bind(note), CONNECT_ONE_SHOT)
		return
	
	_displaying = note
	
	_on_note_title_changed()
	_on_note_description_changed()
	
	_connections.append(Connection.new(note.title_changed, _on_note_title_changed.unbind(2), true))
	_connections.append(Connection.new(note.description_changed, _on_note_description_changed.unbind(2), true))
	
	
	if NoteUI.all.has(_displaying.get_script()):
		for note_ui: NoteUI in NoteUI.all[_displaying.get_script()].get_heritage():
			for widget_scene in note_ui.display_widgets:
				var widget: DisplayWidget = widget_scene.instantiate()
				display_widgets.add_child(widget)
				if widget.before:
					display_widgets.move_child(widget, 1)
				
				widget.note = _displaying
	

func undisplay() -> void:
	if  _displaying == null:
		return
	
	while _connections:
		_connections.pop_back().destroy()
		
	while _display_widgets:
		_display_widgets.pop_back().queue_free()
	
	_displaying = null


func _on_note_title_changed() -> void:
	title.text = _displaying.title


func _on_note_description_changed() -> void:
	title.tooltip_text = _displaying.description if _displaying.description else tr("NO_DESCRIPTION")


func _on_title_text_changed(new: String, _old: String):
	_displaying.title = new


func _on_delete_pressed() -> void:
	request_remove.emit()
