class_name GripComponent
extends Control


## A componnent allowing to drag a GUI element.
## 
## [br][br][b]Note:[b] Changing in wich tree the grip is will cause errors.


@export var element_to_move: Control
@export var right_click_to_cancel: bool = true
@export var drag_group: StringName = &"default"
@export_group("dropping")
@export_range(0, 1, 10**-9, "suffix:%") var center_ratio: float = 0.5
## A Bitmask of enabled sides to drop dragged elements.
@export_flags("Center", "Up", "Right", "Down", "Left") var sides: int = 0b1111_1
@export_group("offset")
## If true, [member offset] will be automatically defined so that starting dragging
## does not teleport the GUI to the mouse. Else [member offset] is left unchanged.
@export var auto_offset: bool = true
@export var offset: Vector2 = Vector2.ZERO


static var all: Array[GripComponent] = []

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


func _init() -> void:
	all.append(self)


func _ready() -> void:
	set_process_input(false)


func _notification(what: int) -> void:
	if what == NOTIFICATION_PREDELETE:
		all.erase(self)


#func _process(_delta) -> void:
	#update_ghost_position()


func _input(event: InputEvent) -> void:
	if event.is_action(&"cancel_ongoing_behavior"):
		abort_dragging()
	if _dragging and event is InputEventMouseMotion:
		update_ghost_position()
		update_grip_areas()


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
	set_process_input(false)
	DisplayServer.cursor_set_shape(DisplayServer.CURSOR_ARROW)
	element_to_move.modulate = _starting_element_modulate
	_ghost_element = null
	remove_areas()
	_dragging = false


func update_ghost_position() -> void:
	_ghost_element.global_position = get_global_mouse_position() + offset


var _areas: Array[GripDropArea] = []
func update_grip_areas() -> void:
	var mouse_position: Vector2 = get_global_mouse_position()
	var found: GripComponent
	for grip in all:
		if grip.element_to_move.get_global_rect().has_point(mouse_position):
			found = grip
			break
	
	remove_areas()
	
	if not found:
		_drop_icon = null
		return
	
	for area in GripDropArea.get_areas(
		found.element_to_move.get_global_rect(),
		sides,
		center_ratio,
	):
		_CANVAS.add_child(area)
		_areas.append(area)
		area.target = found.element_to_move
	
	_update_drop_icon()


func remove_areas() -> void:
	while _areas:
		_areas.pop_back().free()


var _drop_icon: DropIcon:
	set(new):
		if _drop_icon:
			_drop_icon.queue_free()
		_drop_icon = new

func _update_drop_icon() -> void:
	var mouse_global_position: Vector2 = get_global_mouse_position()
	var found: GripDropArea
	for area in _areas:
		if Geometry2D.is_point_in_polygon(mouse_global_position, area.polygon):
			found = area
			break
	
	if not found:
		_drop_icon = null
		return
	
	if not _drop_icon:
		_drop_icon = DropIcon.instantiate()
		_CANVAS.add_child(_drop_icon)
	
	_drop_icon.global_position = found.target.global_position
	_drop_icon.size = found.target.size
	prints(_drop_icon.size, found.target.size)
	_drop_icon.side = found.side
	
