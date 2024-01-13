class_name GripComponent
extends Control


## A componnent allowing to drag a GUI element.
## 
## [br][br][b]Note:[b] Changing in wich tree the grip is will cause errors.


@export var element_to_move: Control
@export var right_click_to_cancel: bool = true
@export_group("offset")
## If true, [member offset] will be automatically defined so that starting dragging
## does not teleport the GUI to the mouse. Else [member offset] is left unchanged.
@export var auto_offset: bool = true
@export var offset: Vector2 = Vector2.ZERO


static var moved_element_modulate: Color = Color.TRANSPARENT
static var ghost_modulate: Color = Color(1, 1, 1, 0.4)


var _CANVAS: CanvasLayer:
	get:
		if not _CANVAS:
			_CANVAS = get_node_or_null(^"/root/GripCanvas")
			if not _CANVAS:
				_CANVAS = CanvasLayer.new()
				_CANVAS.layer = 512
				get_tree().root.add_child(_CANVAS)
		return _CANVAS


var _dragging: bool = false
#var _starting_mouse_global_position: Vector2 = Vector2(-1, -1)
## Automatically add the element to tree and free it when unreferenced.
var _ghost_element: Control:
	set(new):
		if _ghost_element:
			_CANVAS.remove_child(_ghost_element)
			_ghost_element.queue_free()
		_ghost_element = new
		if new:
			new.modulate = ghost_modulate
			new.size = element_to_move.size
			update_ghost_position()
			_CANVAS.add_child(new)
var _starting_element_modulate: Color


func _ready() -> void:
	set_process_input(false)


#func _process(_delta) -> void:
	#update_ghost_position()


func _input(event: InputEvent) -> void:
	if event.is_action(&"cancel_ongoing_behavior"):
		abort_dragging()
	if _dragging and event is InputEventMouseMotion:
		update_ghost_position()


func start_dragging() -> void:
	if _dragging:
		return
	
	if element_to_move == null:
		push_warning("No element to drag.")
		return
	
	_dragging = true
	
	if auto_offset:
		offset = element_to_move.global_position - get_global_mouse_position()
	
	_starting_element_modulate = element_to_move.modulate
	element_to_move.modulate = moved_element_modulate
	_ghost_element = element_to_move.duplicate(0)
	DisplayServer.cursor_set_shape(DisplayServer.CURSOR_DRAG)
	
	set_process_input(true)
	
	#_starting_mouse_global_position = get_global_mouse_position()


func finish_dragging() -> void:
	abort_dragging()


func abort_dragging() -> void:
	DisplayServer.cursor_set_shape(DisplayServer.CURSOR_ARROW)
	element_to_move.modulate = _starting_element_modulate
	_ghost_element = null
	set_process_input(false)
	_dragging = false


func update_ghost_position() -> void:
	_ghost_element.global_position = get_global_mouse_position() + offset
