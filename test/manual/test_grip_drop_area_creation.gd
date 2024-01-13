extends Control

@onready var grip_component: GripComponent = $GripComponent

@export var manually_update: bool = true:
	set(new):
		update()
		manually_update = new


func _process(_delta: float) -> void:
	update()


var _areas: Array[GripDropArea] = []

func update() -> void:
	while _areas:
		_areas.pop_back().queue_free()

	for area in GripDropArea.get_areas(get_rect(), grip_component.sides, grip_component.center_ratio):
		add_child(area)
		_areas.append(area)
