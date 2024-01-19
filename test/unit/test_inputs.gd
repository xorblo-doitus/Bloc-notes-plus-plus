extends GutTest



func test_editable_rich_text_label() -> void:
	var editable_rich_text_label: RichTextEdit = RichTextEdit.instantiate()
	editable_rich_text_label.text = "Start"
	editable_rich_text_label.custom_minimum_size = Vector2(500, 500)
	get_tree().root.add_child(editable_rich_text_label)
	
	watch_signals(editable_rich_text_label)
	
	#var sender = InputSender.new(editable_rich_text_label)
	var double_click: InputEventMouse = InputFactory.mouse_double_click(Vector2.ZERO)
	double_click.pressed = true
	
	assert_eq(
		editable_rich_text_label.text,
		"Start",
		"text is not the initial text."
	)
	
	assert_false(editable_rich_text_label.editing)
	#sender.send_event(double_click)
	editable_rich_text_label.code_edit.grab_focus()
	assert_true(editable_rich_text_label.editing)
	
	assert_eq(
		editable_rich_text_label.text,
		"Start",
		"text changed by edition without input."
	)
	
	editable_rich_text_label.editing = true
	editable_rich_text_label.code_edit.text = "hello"
	
	assert_signal_not_emitted(editable_rich_text_label, &"text_changed", "Emited but text did not change.")
	
	var sender2 = InputSender.new(editable_rich_text_label.code_edit)
	var validate: InputEventKey = InputFactory.key_down(KEY_ENTER)
	validate.shift_pressed = true
	sender2.send_event(validate)
	
	assert_signal_emitted_with_parameters(
		editable_rich_text_label,
		&"text_changed",
		["hello", "Start"]
	)
	
	assert_false(
		editable_rich_text_label.editing,
		"Validating does not validate."
	)
	
	assert_eq(
		editable_rich_text_label.text,
		"hello",
		"text not updated by editing."
	)
	
	assert_ne(
		editable_rich_text_label.text,
		"hello\n",
		"Validating create a \\n (line break)."
	)
	
	editable_rich_text_label.free()
