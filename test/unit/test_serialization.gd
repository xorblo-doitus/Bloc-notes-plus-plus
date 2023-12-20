extends GutTest

const builtins: Array = [
	-1,
	1,
	-10.8,
	21.9,
	"AH",
	&"OH",
	true,
	false,
]

func test_builtins():
	for builtin in builtins:
		assert_eq(
			builtin,
			Serializer.deserialize(Serializer.serialize(builtin)),
			"Save and load alters information"
		)
