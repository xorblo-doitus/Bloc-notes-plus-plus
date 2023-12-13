extends Object
class_name Serializer

## Let serialize Objects
## 
## Search for an [code]attributes_to_serialize[/code] constant in objects
## to serialize them or a [code]special_JSONablization[/code] method
## wich should append special data to the [Dictionary] passed as argument to it.


## Turns [param target] into a JSONable dictionary.
static func JSONablize_object(target: Object) -> Dictionary:
	var data: Dictionary = {}
	
	if &"attributes_to_serialize" in target:
		for attribute in target.attributes_to_serialize:
			data[attribute] = Serializer.JSONablize(target)
		
		if target.has_method(&"special_JSONablization"):
			target.special_JSONablization(data)
	
	if data.is_empty():
		assert(false, "Unable to JSONablize {target}.".format({
			"target": target
		}))
	
	return data


## All types that can be handled automatically by Godot's JSON class.
const JSONable = [
	TYPE_STRING,
	TYPE_INT,
	TYPE_FLOAT,
	TYPE_BOOL,
]

const JSONabilization: Dictionary = {
	&"Note": {
		
	}
}

## Turns [param target] into a JSONable object
## ([Dictionary], [Array], [int], [String]...)
static func JSONablize(target: Variant) -> Variant:
	match typeof(target):
		TYPE_OBJECT:
			return Serializer.JSONablize_object(target)
			
		TYPE_ARRAY:
			var new_array := []
			for element in target:
				new_array.push_back(JSONablize(element))
			return new_array
			
		TYPE_DICTIONARY:
			var new_dictionary := []
			for key in target:
				new_dictionary[key] = JSONablize(target[key])
			return new_dictionary
			
		var type when type in JSONable:
			return target
	
	assert(false, "Unable to JSONablize {target}.".format({
		"target": target
	}))
	
	return null