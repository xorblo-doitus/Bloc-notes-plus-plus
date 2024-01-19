extends GutTest



func test_varialble_freed() -> void:
	var start_len: int = len(Variable.all)
	var _variable: Variable = Variable.new("1+1")
	
	assert_eq(
		len(Variable.all),
		start_len + 1,
		"Variable is not added to all references."
	)
	
	_variable = null
	
	assert_eq(
		len(Variable.all),
		start_len,
		"Variable is not removed from all references when freed."
	)



func test_calculus() -> void:
	var calculus: Calculus = Calculus.new("1+1", "Description bidon.")
	
	assert_eq(
		calculus.get_value(),
		2.0,
		"Calculus calculation does not work."
	)
	
	calculus.title = "Vector2((4.5*2)/(3-1.0) + PI, sqrt(36))"
	assert_eq(
		calculus.get_value(),
		Vector2(4.5 + PI, 6),
		"Calculus calculation does not work."
	)


func test_variable() -> void:
	var variable: Variable = Variable.new("10/2")
	variable.name = "a"
	
	var calculus: Calculus = Calculus.new("a + 100")
	
	assert_eq(
		calculus.get_value(),
		105,
		"Variables don't work."
	)


func test_float_to_int() -> void:
	var expected := {
		"1": "1.0",
		"-1": "-1.0",
		"1/3": "1.0/3.0",
		"1/1-3": "1.0/1.0-3.0",
		"Vector2(2, 6)": "Vector2(2.0, 6.0)",
		"1.5/-6.+.9": "1.5/-6.+.9",
	}
	
	for input in expected:
		assert_eq(
			Calculus.ints_to_floats(input),
			expected[input],
			"Convertion of ints to floats failed."
		)
