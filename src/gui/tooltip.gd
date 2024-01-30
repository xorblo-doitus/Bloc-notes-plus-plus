class_name Tooltip
extends RichTextLabel


## A reference to the default packed scene associated with this class
static var _default_scene: PackedScene:
	get:
		if _default_scene == null:
			_default_scene = FilePathes.get_resource(&"tooltip")
		return _default_scene

## Create a new instance by loading default scene for this class.
static func instantiate(_text: String) -> Tooltip:
	return _default_scene.instantiate().set_text_chainable(_text)


func _ready() -> void:
	get_parent().add_to_group(&"window")
	
	if get_tree().root.always_on_top:
		get_parent().always_on_top = true
		get_parent().move_to_foreground()


func set_text_chainable(new: String) -> Tooltip:
	text = new
	return self
