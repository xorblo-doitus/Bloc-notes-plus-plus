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
	print(Variable.all)
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
