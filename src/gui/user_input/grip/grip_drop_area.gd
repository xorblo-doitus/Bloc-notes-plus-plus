class_name GripDropArea
extends Polygon2D


## A polygon representing a side where to place a dragged element relatively to another element.
## 
## You can check in wich [GripDropArea] the mouse pointer is to know to wich side
## you should add the dragged element.


const ALL_SIDES = 0b1111_1
const COLUMN = 0b0101_1
const LINE = 0b1010_1


## Represents the side to wich a dragged element can be inserted.
enum Side {
	CENTER = 2**0,
	UP = 2**1,
	RIGHT = 2**2,
	DOWN = 2**3,
	LEFT = 2**4,
}


static var side_color: Dictionary = {
	GripDropArea.Side.CENTER: Color.BLUE,
	GripDropArea.Side.UP: Color.RED,
	GripDropArea.Side.RIGHT: Color.BLUE_VIOLET,
	GripDropArea.Side.DOWN: Color.GREEN,
	GripDropArea.Side.LEFT: Color.YELLOW,
}


var side: GripDropArea.Side = Side.CENTER:
	set(new):
		color = side_color[new]
		side = new


## Creates all [GripDropArea] representing the allowed sides to wich an element can
## be insterted.
## [br][br][param global_rest]: the global rect of the pointed element.
## [br][br][param enabled_sides]: a mask of [enum GripDropArea.Side].
## [br][br][param center_ratio]: The fraction of the space allowed to center.
## Defaults to 0.5, i.e. half of height is allowed to center, and up and down side have
## each a quarter, meaning that there is still a half allowed to insert an element
## between two others, because the up side of one is connected to the bottom one of the other.
## [br][br][b]Note:[/b] Return order: Center, up, right, down, left
## [br][br][b]Note:[/b] Polygons points are clockwise ordered, starting from their up left corner.
static func get_areas(global_rect: Rect2, enabled_sides: int = ALL_SIDES, center_ratio: float = 1.0/2.0) -> Array[GripDropArea]:	
	if not Side.CENTER & enabled_sides:
		center_ratio = 0
	
	var sides_ratio: float = (1-center_ratio) / 2
	
	#region Find only coords for the center
	var center_up_right_corner = global_rect.position + Vector2(global_rect.size.x, 0)
	if Side.UP & enabled_sides:
		center_up_right_corner.y += global_rect.size.y * sides_ratio
	if Side.RIGHT & enabled_sides:
		center_up_right_corner.x -= global_rect.size.x * sides_ratio
	
	var center_down_right_corner = global_rect.end
	if Side.DOWN & enabled_sides:
		center_down_right_corner.y -= global_rect.size.y * sides_ratio
	if Side.RIGHT & enabled_sides:
		center_down_right_corner.x -= global_rect.size.x * sides_ratio
	
	var center_down_left_corner = global_rect.position + Vector2(0, global_rect.size.y)
	if Side.DOWN & enabled_sides:
		center_down_left_corner.y -= global_rect.size.y * sides_ratio
	if Side.RIGHT & enabled_sides:
		center_down_left_corner.x += global_rect.size.x * sides_ratio
	
	var center_up_left_corner = global_rect.position
	if Side.DOWN & enabled_sides:
		center_up_left_corner.y += global_rect.size.y * sides_ratio
	if Side.RIGHT & enabled_sides:
		center_up_left_corner.x += global_rect.size.x * sides_ratio
	#endregion
	
	var result: Array[GripDropArea] = []
	
	#region Create areas
	if Side.CENTER & enabled_sides:
		result.append(GripDropArea.new(Side.CENTER, clean_polygon([
			center_up_left_corner,
			center_up_right_corner,
			center_down_right_corner,
			center_down_left_corner,
		])))
	
	if Side.UP & enabled_sides:
		result.append(GripDropArea.new(Side.UP, clean_polygon([
			global_rect.position,
			global_rect.position + Vector2(global_rect.size.x, 0),
			center_up_right_corner,
			center_up_left_corner,
		])))
	
	if Side.RIGHT & enabled_sides:
		result.append(GripDropArea.new(Side.RIGHT, clean_polygon([
			center_up_right_corner,
			global_rect.position + Vector2(global_rect.size.x, 0),
			global_rect.end,
			center_down_right_corner,
		])))
	
	if Side.DOWN & enabled_sides:
		result.append(GripDropArea.new(Side.DOWN, clean_polygon([
			center_down_left_corner,
			center_down_right_corner,
			global_rect.end,
			global_rect.position + Vector2(0, global_rect.size.y),
		])))
	if Side.LEFT & enabled_sides:
		result.append(GripDropArea.new(Side.LEFT, clean_polygon([
			global_rect.position,
			center_up_left_corner,
			center_down_left_corner,
			global_rect.position + Vector2(0, global_rect.size.y),
		])))
	#endregion
	
	return result


static func clean_polygon(to_clean: PackedVector2Array) -> PackedVector2Array:
	var cleaned: PackedVector2Array = PackedVector2Array()
	var _last: Vector2 = Vector2.INF
	
	for point in to_clean:
		if point.is_equal_approx(_last):
			continue
		
		_last = point
		cleaned.append(point)
	
	return cleaned


func _init(_side: GripDropArea.Side, _polygon: PackedVector2Array) -> void:
	side = _side
	polygon = _polygon
	@warning_ignore("integer_division")
	z_index = RenderingServer.CANVAS_ITEM_Z_MIN / 2
	modulate = Color(1, 1, 1, 0.4)
