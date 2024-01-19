extends GutTest


func test_object():
	var success: bool = true
	var variable: Variable = Variable.new()
	
	variable.title = "1+1"
	variable.description = "Ben en fait euh j'ai pas d'idée de description."
	variable.name = "my_var"
	
	var loaded: Variable = Serializer.deserialize(Serializer.serialize(variable))
	
	
	if variable.title != loaded.title:
		fail_test("Title serialization does not work on Variable.")
		success = false
	if variable.description != loaded.description:
		fail_test("Description serialization does not work on Variable.")
		success = false
	if variable.name != loaded.name:
		fail_test("Name serialization does not work on Variable.")
		success = false
	
	
	if success:
		pass_test("Variable serialization work.")
