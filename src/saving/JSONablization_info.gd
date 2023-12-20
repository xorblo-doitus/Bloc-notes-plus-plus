extends RefCounted
class_name JSONablizationInfo


## Static variable storing inforamations about how to [method JSONablize]
## and read JSONabled [Object]s
static var all: Dictionary = {}


static func get_most_precise(object: Object) -> JSONablizationInfo:
	var matching: Array[JSONablizationInfo] = []
	
	for info in JSONablizationInfo.all.values:
		if is_instance_of(object, info.type):
			matching.push_back(info)
	
	assert(not matching.is_empty(), "No informations for " + str(object))
	
	var result: JSONablizationInfo = matching.pop_back()
	
	while not matching.is_empty():
		var found: bool = false # There is no `for else` like in python
		
		for info in matching:
			if info.inherit == result:
				# There is a more precise 
				result = matching.pop_back()
				found = true
				break
		
		assert(found, "Multiple matching JSONablizationInfo (%s) found for %s, did you forgot an inheritance?" % [str(matching), str(object)])
	
	return result


## The class of the object to store. ([Note], [Variable]...)
var type: Object
## The class name of the object to store.
## ([code]"Note"[/code], [code]"Variable"[/code]...)
var type_as_text: String
## A list of attributes to save
var attributes_to_save: Array[String] = []
## A special function that will be called with a dictionary
## to wich it should add necessary informations.
var special_serialization: Callable
## A special function that will be called with a dictionary and an object
## to wich it should load necessary informations
## from the ones stored in the dictionary.
var special_load: Callable
## A JSONablizationInfo instance from wich infos are inherited
var inherit: JSONablizationInfo


func _init(_type: Object, _type_as_text: String, _attributes_to_save: Array[String] = []):
	type = _type
	type_as_text = _type_as_text
	attributes_to_save.append_array(_attributes_to_save)


## Optional special functions.
## See [member special_serialization] and [member special_load].
## Returns self.
func set_special_infos(serializer: Callable, loader: Callable) -> JSONablizationInfo:
	special_serialization = serializer
	special_load = loader
	return self


func set_inherit(new_inherit: JSONablizationInfo) -> JSONablizationInfo:
	inherit = new_inherit
	return self


func set_inherit_by_name(name: StringName) -> JSONablizationInfo:
	for other_name in JSONablizationInfo.all:
		if other_name == name:
			inherit = JSONablizationInfo.all[other_name]
			return self
	assert(false, "No JSONablizationInfo for " + name)
	return self


## Build this JSONablizationInfo.
## [b]DO NOT MODIFY THIS INSTANCE AFTERWARD[/b]
func build() -> JSONablizationInfo:
	JSONablizationInfo.all[type_as_text] = self
	return self


func get_consecutive_infos() -> Array[JSONablizationInfo]:
	var result: Array[JSONablizationInfo] = [self]
	
	while result[-1].inherit:
		result.push_back(result[-1].inherit)
	
	return result
