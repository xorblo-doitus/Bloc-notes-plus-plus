@tool
class_name DropIcon
extends AspectRatioContainer


const INSERT = preload("res://src/assets/images/icons/insert.png")
const ROTATIONS = {
	GripDropArea.Side.CENTER: 0,
	GripDropArea.Side.UP: 0,
	GripDropArea.Side.RIGHT: PI/2,
	GripDropArea.Side.DOWN: PI,
	GripDropArea.Side.LEFT: -PI/2,
}
const H_ALIGNS = {
	GripDropArea.Side.CENTER: ALIGNMENT_CENTER,
	GripDropArea.Side.UP: ALIGNMENT_CENTER,
	GripDropArea.Side.RIGHT: ALIGNMENT_END,
	GripDropArea.Side.DOWN: ALIGNMENT_CENTER,
	GripDropArea.Side.LEFT: ALIGNMENT_BEGIN,
}
const V_ALIGNS = {
	GripDropArea.Side.CENTER: ALIGNMENT_CENTER,
	GripDropArea.Side.UP: ALIGNMENT_BEGIN,
	GripDropArea.Side.RIGHT: ALIGNMENT_CENTER,
	GripDropArea.Side.DOWN: ALIGNMENT_END,
	GripDropArea.Side.LEFT: ALIGNMENT_CENTER,
}


@export var side: GripDropArea.Side = GripDropArea.Side.RIGHT:
	set(new):
		side = new
		if icon:
			icon.material.set_shader_parameter("rotation_clockwise", ROTATIONS[side])
			print(icon.rotation)
			alignment_horizontal = H_ALIGNS[side]
			alignment_vertical = V_ALIGNS[side]
			_on_resized()

@onready var icon: TextureRect = %Icon


## A reference to the default packed scene associated with this class
static var _default_scene: PackedScene:
	get:
		if _default_scene == null:
			_default_scene = load("res://src/gui/user_input/grip/drop_icon.tscn")
		return _default_scene

## Create a new instance by loading default scene for this class.
static func instantiate() -> DropIcon:
	return _default_scene.instantiate()


func _ready() -> void:
	_on_resized()
	
	var tween = create_tween().set_loops().set_speed_scale(1.5)
	tween.tween_property(icon, "modulate", Color(0, 1, 0), 0.2).from(Color(1, 1, 1))
	tween.tween_property(icon, "modulate", Color(1, 1, 1), 0.2).from(Color(0, 1, 0))
	tween.tween_property(icon, "modulate", Color(1, 1, 1), 0.1)
	tween.tween_property(icon, "modulate", Color(0, 1, 0), 0.2).from(Color(1, 1, 1))
	tween.tween_property(icon, "modulate", Color(1, 1, 1), 0.2).from(Color(0, 1, 0))
	tween.tween_property(icon, "modulate", Color(1, 1, 1), 0.5)
	
	# Call setters
	side = side


func _on_resized() -> void:
	icon.pivot_offset = icon.size / 2
