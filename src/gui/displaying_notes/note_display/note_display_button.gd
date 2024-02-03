extends Button


func _make_custom_tooltip(for_text: String) -> Object:
	return Tooltip.instantiate(for_text)
