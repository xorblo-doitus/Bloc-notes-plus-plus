extends GutTest


func test_note_display():
	var note := Note.new()
	note.title = "Start"
	note.description = "Une desc"
	var display: NoteDisplay = NoteDisplay.instantiate()
	get_tree().root.add_child(display)
	
	display.display(note)
	
	assert_eq(
		display.title.text,
		"Start",
		"Title not synced between note and display at initialization."
	)
	assert_eq(
		display.title.tooltip_text,
		"Une desc",
		"Description not synced between note and display at initialization."
	)
	
	display.title.text = "Nouveau titre"
	display.title.text_changed.emit("Nouveau titre", "Start")
	
	assert_eq(
		note.title,
		"Nouveau titre",
		"Title not synced between note and display at user edition."
	)
	#assert_eq(
		#display.description,
		#"Une desc",
		#"Description not synced between note and display at user edition."
	#)
	
	note.title = "Encore un nouveau titre"
	assert_eq(
		display.title.text,
		"Encore un nouveau titre",
		"Title not synced between note and display at note modification."
	)
	
	display.free()
