class_name BuilderGUI
extends ConfirmationDialog


signal finished()


static var _TYPE_IDS = []
	#Note,
	#Calculus,
	#Variable,
	#Task,
#]


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


static func _fetch_types() -> void:
	for type in NoteUI.all:
		_TYPE_IDS.append(type)


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


@onready var type_selector: OptionButton = %TypeSelector
@onready var tabs: TabContainer = %Tabs


#func _init() -> void:
	#transient = true
	#exclusive = true


func _ready() -> void:
	var HBox: HBoxContainer = get_ok_button().get_parent()
	HBox.move_child(get_ok_button(), 2)
	HBox.move_child(get_cancel_button(), 1)
	
	for ui: NoteUI in NoteUI.all.values():
		type_selector.add_item(ui.type_translation_key)
	
	if get_tree().root.always_on_top:
		always_on_top = true
		move_to_foreground()


#func _on_visibility_changed() -> void:
	#if not visible:
		#mode = Window.MODE_WINDOWED
		#show.call_deferred()


func update() -> void:
	if not is_node_ready():
		ready.connect(update, CONNECT_ONE_SHOT)
		return
	
	type_selector.selected = _TYPE_IDS.find(builder.type)
	
	for tab in tabs.get_children():
		tabs.remove_child(tab)
	
	
	for ui in NoteUI.get_most_precise(builder.type).get_heritage(true):
	#for info in BuildingInfo.get_most_precise(builder.type).get_consecutive_infos():
		var new_tab: BoxContainer = preload("res://src/gui/user_input/note_edition/builder_gui/builder_gui_tab.tscn").instantiate()
		
		for widget_edit_scene in ui.widget_edits:
			var new_widget: WidgetEdit = widget_edit_scene.instantiate()
			new_widget.builder = builder
			new_tab.add_child(new_widget)
		
		if not ui.widget_edits:
			new_tab.add_child(preload("res://src/gui/user_input/note_edition/widget_edits/no_widget_edit.tscn").instantiate())
		
		new_tab.name = ui.type_translation_key
		
		tabs.add_child(new_tab)

func _finish() -> void:
	finished.emit()


func _on_type_selector_item_selected(index: int) -> void:
	builder.type = _TYPE_IDS[index]
	update()
