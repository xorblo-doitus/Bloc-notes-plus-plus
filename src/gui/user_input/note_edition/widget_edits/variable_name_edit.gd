extends WidgetEdit


@onready var error_button: ErrorButton = %ErrorButton
@onready var variable_name_input: RichTextEdit = %VariableNameInput


func _connect_to(_builder: Builder) -> void:
	_builder.attribute_changed.connect(_on_attribute_updated)
	update_name(_builder.attributes.get("name", ""))


func _on_attribute_updated(attribute: String, new_value: Variant) -> void:
	match attribute:
		"name":
			update_name(new_value)


func _on_variable_name_input_text_changed(new: String, _old: String) -> void:
	builder.set_attribute("name", new)
	check_name(new)


func update_name(new: String) -> void:
	variable_name_input.text = new
	check_name(new)


func check_name(_name: String) -> void:
	if not is_node_ready():
		ready.connect(check_name.bind(_name), CONNECT_ONE_SHOT)
		return
	error_button.error = Task.check_name(_name)
