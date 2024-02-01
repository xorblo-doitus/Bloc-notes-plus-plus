extends WidgetEdit


@onready var description_input: RichTextEdit = %DescriptionInput


func _connect_to(_builder: Builder) -> void:
	_builder.attribute_changed.connect(_on_attribute_updated)
	description_input.text = _builder.attributes.get("description", "")


func _on_attribute_updated(attribute: String, new_value: Variant) -> void:
	match attribute:
		"description":
			description_input.text = new_value


func _on_description_input_text_changed(new: String, _old: String) -> void:
	builder.set_attribute("description", new)
