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
	# Do NOT put int into arrays/dict, as float/int comparison in them result in an unequality
	[1.0, "a"],
	{"b": 2.0},
]

func test_builtins():
	for builtin in builtins:
		var loaded = Serializer.deserialize(Serializer.serialize(builtin))
		assert_eq(
			builtin,
			loaded,
			"Serializing then deserializing alters information."
		)



class DummyObject:
	var machin
	var truc
	static func serialize(target: DummyObject, data: Dictionary) -> Dictionary:
		data["azerty"] = target.truc
		return data
	static func deserialize(target: DummyObject, data: Dictionary) -> DummyObject:
		target.truc = data["azerty"]
		return target

class DummyToo extends DummyObject:
	var machin_too
	var truc_too
	static func serialize(target: DummyObject, data: Dictionary) -> Dictionary:
		data["qsdfg"] = target.truc_too
		return data
	static func deserialize(target: DummyObject, data: Dictionary) -> DummyObject:
		target.truc_too = data["qsdfg"]
		return target

func test_object():
	var success: bool = true
	var dummy: DummyObject = DummyObject.new()
	var dummy_too: DummyToo = DummyToo.new()
	
	dummy.machin = {"valeur_machin": 123.0}
	dummy.truc = ["valeur_truc", 987.0]
	dummy_too.machin_too = {"valeur_machin_too": 456.0}
	dummy_too.truc_too = ["valeur_truc_too", 741.0]
	
	var _dummy := JSONablizationInfo.new(DummyObject, &"DummyObject", [
		&"machin",
	]).set_special_serialization(
		DummyObject.serialize,
		DummyObject.deserialize,
	).build()
	var _dummy_too :=JSONablizationInfo.new(DummyToo, &"DummyToo", [
		&"machin_too",
	]).set_special_serialization(
		DummyToo.serialize,
		DummyToo.deserialize,
	).set_inherit(_dummy).build()
	
	
	assert_eq(
		_dummy_too,
		JSONablizationInfo.get_most_precise(dummy_too),
		"Getting most precise class does not work."
	)
	
	
	var loaded: DummyObject = Serializer.deserialize(Serializer.serialize(dummy))
	var loaded_too: DummyToo = Serializer.deserialize(Serializer.serialize(dummy_too))
	
	if dummy.machin != loaded.machin:
		fail_test("Attribute serialization does not work")
		success = false
	if dummy.truc != loaded.truc:
		fail_test("Special serialization does not work")
		success = false
		
	if dummy_too.machin_too != loaded_too.machin_too:
		fail_test("Inherited attribute serialization does not work")
		success = false
	if dummy_too.truc_too != loaded_too.truc_too:
		fail_test("Inherited special serialization does not work")
		success = false
	
	if success:
		pass_test("Object serialization work.")
