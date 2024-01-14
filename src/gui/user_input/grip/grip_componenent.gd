class_name GripComponent
extends Control


## A componnent allowing to drag a GUI element.
## 
## [br][br][b]Note:[b] Changing in wich tree the grip is will cause errors.


## Emitted when an element was dropped onto this one.
signal element_dropped(element_to_drop: Control, on_side: GripDropArea.Side)
## Emitted when the element to move was drag and dropped to somewhere else.
signal left()


## The element this grip let move.
@export var element_to_move: Control
## If true, right-clicking while dragging will cancel the dragging
@export var right_click_to_cancel: bool = true
@export var drag_group: StringName = &"default"
@export var drop_enabled: bool = true
@export_group("dropping")
@export_range(0, 1, 10**-3, "suffix:%") var center_ratio: float = 0.5
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

#region Dragging variables
var _dragging: bool = false
var _current_area: GripDropArea
#endregion

#region Drawing related variables
var _CANVAS: CanvasLayer:
	get:
		if not _CANVAS:
			_CANVAS = get_node_or_null(^"/root/GripCanvas")
			if not _CANVAS:
				_CANVAS = CanvasLayer.new()
				_CANVAS.layer = 512
				get_tree().root.add_child(_CANVAS)
		return _CANVAS

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

var _areas: Array[GripDropArea] = []

var _drop_icon: DropIcon:
	set(new):
		if _drop_icon:
			_CANVAS.remove_child(_drop_icon)
			_drop_icon.queue_free()
		_drop_icon = new
		if _drop_icon:
			_CANVAS.add_child(_drop_icon)

var _starting_element_modulate: Color
#endregion


func _init() -> void:
	all.append(self)


func _ready() -> void:
	set_process_input(false)


func _notification(what: int) -> void:
	if what == NOTIFICATION_PREDELETE:
		all.erase(self)


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


func finish_dragging() -> void:
	if _current_area != null and is_instance_valid(_current_area):
		left.emit()
		_current_area.target_grip.element_dropped.emit(element_to_move, _current_area.side)
	abort_dragging()


func abort_dragging() -> void:
	set_process_input(false)
	DisplayServer.cursor_set_shape(DisplayServer.CURSOR_ARROW)
	element_to_move.modulate = _starting_element_modulate
	_clean_visuals()
	_dragging = false


func update_ghost_position() -> void:
	_ghost_element.global_position = get_global_mouse_position() + offset



func update_grip_areas() -> void:
	var mouse_position: Vector2 = get_global_mouse_position()
	var found_grip: GripComponent
	for grip in all:
		if not grip.drop_enabled:
			continue
		
		if grip.drag_group != drag_group:
			continue
		
		if grip == self:
			continue
		
		if grip.element_to_move.get_global_rect().has_point(mouse_position):
			found_grip = grip
			break
	
	_remove_areas()
	
	if not found_grip:
		_drop_icon = null
		_current_area = null
		return
	
	for area in GripDropArea.get_areas(
		found_grip.element_to_move.get_global_rect(),
		sides,
		center_ratio,
	):
		_CANVAS.add_child(area)
		_areas.append(area)
		area.target_grip = found_grip
	
	_update_drop_icon()


func _update_drop_icon() -> void:
	var mouse_global_position: Vector2 = get_global_mouse_position()
	var found_area: GripDropArea
	for area in _areas:
		if Geometry2D.is_point_in_polygon(mouse_global_position, area.polygon):
			found_area = area
			break
	
	if not found_area:
		_drop_icon = null
		_current_area = null
		return
	
	_current_area = found_area
	
	if not _drop_icon:
		_drop_icon = DropIcon.instantiate()
	
	_drop_icon.global_position = found_area.target_grip.element_to_move.global_position
	_drop_icon.size = found_area.target_grip.element_to_move.size
	_drop_icon.side = found_area.side


func _clean_visuals() -> void:
	_remove_areas()
	_drop_icon = null
	_ghost_element = null


func _remove_areas() -> void:
	while _areas:
		_areas.pop_back().free()
