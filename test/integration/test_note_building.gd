extends GutTest


func test_build() -> void:
	var builder: Builder = Builder.new()
	
	builder.type = Note
	
	assert_true(
		ST.is_equal(
			builder.build(),
			Note.new()
		),
		"Builder ne crée pas une note vierge même si on ne lui donne aucune information"
	)
	
	builder.set_attribute("title", "Bonjour")
	builder.set_attribute("description", "Blabla")
	
	assert_true(
		ST.is_equal(
			builder.build(),
			Note.new("Bonjour", "Blabla")
		),
		"Wrong title and description after building."
	)
	
	var note: Note = Note.new()
	builder.apply_to_existing(note)
	
	assert_true(
		ST.is_equal(
			note,
			Note.new("Bonjour", "Blabla")
		),
		"Builder.apply_to_existing(object) don't work."
	)


func test_type_switching() -> void:
	var variable: Variable = Variable.new("1+1", "Description inutile").set_name("ma_variable")
	
	var builder = Builder.new(variable)
	builder.type = Note
	var note: Note = builder.build()
	
	assert_true(
		ST.is_equal(
			note,
			Note.new("1+1", "Description inutile")
		),
		"Builder.edit_object(object) don't work."
	)
	
	var second_builder: Builder = Builder.new(note)
	second_builder.type = Variable
	var second_variable: Variable = second_builder.build()
	
	assert_true(
		ST.is_equal(
			second_variable,
			variable
		),
		"Builder.apply_to_existing(object) don't work."
	)
