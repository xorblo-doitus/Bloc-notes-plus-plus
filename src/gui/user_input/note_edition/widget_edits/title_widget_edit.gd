extends WidgetEdit

## Edition widget for [Note]'s [member Note.title]


@onready var title_input: RichTextEdit = %TitleInput


func _connect_to(_builder: Builder) -> void:
	_builder.attribute_changed.connect(_on_attribute_updated)


## Virtual method. Remember to call super() somewhere.
## Keys are attributes' names and values are their values.
func get_attributes_and_values() -> Dictionary:
	return {}


func _on_attribute_updated(attribute: String, new_value: Variant) -> void:
	match attribute:
		"title":
			title_input.text = new_value


func _on_title_input_text_changed(new: String, _old: String) -> void:
	builder.set_attribute("title", new)
