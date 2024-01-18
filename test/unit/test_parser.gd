extends GutTest

func test_tokenise():
	assert_eq(
		Parser.tokenise("/task 23/06/2024"), 
		["/task", "23/06/2024"], 
		"Tokenise Don't Work"
	)


#func test_parser():
	#assert_eq(Parser.parse())