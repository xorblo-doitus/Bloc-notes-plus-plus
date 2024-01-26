class_name BuilderGUI
extends ConfirmationDialog


signal finished()


## A reference to the default packed scene associated with this class
static var _default_scene: PackedScene:
	get:
		if _default_scene == null:
			_default_scene = FilePathes.get_resource(&"builder_gui")
		return _default_scene

## Create a new instance by loading default scene for this class.
static func instantiate() -> BuilderGUI:
	return _default_scene.instantiate()



static var editing: bool = false


static func request_edition(allow_simultaneous: bool = false) -> BuilderGUI:
	if not allow_simultaneous:
		if editing:
			return null
		editing = true
	
	var new: BuilderGUI = BuilderGUI.instantiate()
	
	if not allow_simultaneous:
		new.finished.connect(BuilderGUI._stop_editing, CONNECT_ONE_SHOT)
	
	return new


static func _stop_editing() -> void:
	
	print("disabled")
	editing = false


var builder: Builder:
	set(new):
		builder = new
		update()


#func _init() -> void:
	#transient = true
	#exclusive = true


func _ready() -> void:
	var HBox: HBoxContainer = get_ok_button().get_parent()
	HBox.move_child(get_ok_button(), 2)
	HBox.move_child(get_cancel_button(), 1)


#func _on_visibility_changed() -> void:
	#if not visible:
		#mode = Window.MODE_WINDOWED
		#show.call_deferred()


func update() -> void:
	pass


func _finish() -> void:
	finished.emit()
