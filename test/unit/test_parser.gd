extends GutTest

func test_tokenise():
	assert_eq(
		Parser.tokenise("/task 23/06/2024"), 
		["/task", "23/06/2024"], 
		"Tokenise Don't Work"
	)


#func test_parser():
	#assert_eq(Parser.parse())

func test_command():
	var builder: Builder = Parser.execute("/store NOMVAR 1+1")["_current_builder"]
	
	assert_eq(
		builder.type , Variable
	)
	
	assert_eq(
		builder.attributes.get("name") , "NOMVAR"
	)
	
	assert_true(
		Variable.new("1+1").set_name("NOMVAR")._is_equal(
		builder.build()
	))