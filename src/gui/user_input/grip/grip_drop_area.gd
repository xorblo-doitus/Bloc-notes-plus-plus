class_name GripDropArea
extends Polygon2D


## A polygon representing a side where to place a dragged element relatively to another element.
## 
## You can check in wich [GripDropArea] the mouse pointer is to know to wich side
## you should add the dragged element.


## Represents the side to wich a dragged element can be inserted.
enum Side {
	CENTER = 2**1,
	UP = 2**2,
	RIGHT = 2**3,
	DOWN = 2**4,
	LEFT = 2**5,
}


var side: GripDropArea.Side = Side.CENTER


## Creates all [GripDropArea] representing the allowed sides to wich an element can
## be insterted.
static func get_areas(global_rect: Rect2, enabled_sides: GripDropArea.Side, center_ratio: float = 1/2) -> Array[GripDropArea]:	
	var sides_ratio: float = (1-center_ratio) / 2
	var center: PackedVector2Array = PackedVector2Array()
	
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
	
	#center.append_array([
		#global_rect.position,
		#global_rect.position + Vector2(global_rect.size.x, 0),
		#global_rect.end,
		#global_rect.position + Vector2(0, global_rect.size.y),
	#])
	#if Side.
	
	#if Side.UP & enabled_sides:
		#up.append_array([
			#global_rect.position,
			#global_rect.position + Vector2(global_rect.size.x, 0),
		#])
		#if Side.CENTER & enabled_sides:
			#center
	
	var result: Array[GripDropArea] = []
	
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
			global_rect.position + Vector2(global_rect.size.x, 0),
			global_rect.end,
			center_down_right_corner,
			center_up_right_corner,
		])))
	
	if Side.DOWN & enabled_sides:
		result.append(GripDropArea.new(Side.DOWN, clean_polygon([
			global_rect.end,
			global_rect.position + Vector2(0, global_rect.size.y),
			center_down_left_corner,
			center_down_right_corner,
		])))
	if Side.LEFT & enabled_sides:
		result.append(GripDropArea.new(Side.LEFT, clean_polygon([
			global_rect.position + Vector2(0, global_rect.size.y),
			global_rect.position,
			center_up_left_corner,
			center_down_left_corner,
		])))
	
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
