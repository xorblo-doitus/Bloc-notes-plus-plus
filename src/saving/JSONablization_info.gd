extends RefCounted
class_name JSONablizationInfo


## Static variable storing inforamations about how to [method JSONablize]
## and read JSONabled [Object]s
static var all: Dictionary = {}


static func compare_precision(a: JSONablizationInfo, b: JSONablizationInfo) -> bool:
	return a.inherit_depth > b.inherit_depth


static func get_most_precise(object: Object) -> JSONablizationInfo:
	var matching: Array[JSONablizationInfo] = []
	
	for info in JSONablizationInfo.all.values():
		if is_instance_of(object, info.type):
			matching.push_back(info)
	
	assert(not matching.is_empty(), "No informations for " + str(object))
	
	matching.sort_custom(JSONablizationInfo.compare_precision)
	
	#var result: JSONablizationInfo = matching.pop_back()
	#
	#while not matching.is_empty():
		#var found: bool = false # There is no `for else` like in python
		#
		#for i in len(matching):
			#var info: JSONablizationInfo = matching[i]
			#if result.inherit == info:
				#matching
			#if info.inherit == result:
				## There is a more precise info
				#result = matching.pop_at(i)
				#found = true
				#break
		#
		#assert(found, "Multiple matching JSONablizationInfo (%s) found for %s, did you forgot an inheritance?" % [str(matching), str(object)])
	
	return matching[0]



## The class of the object to store. ([Note], [Variable]...)
var type: Object
## The class name of the object to store.
## ([code]"Note"[/code], [code]"Variable"[/code]...)
var type_as_text: String
## A list of attributes to save
var attributes_to_save: Array[String] = []
## A special function that will be called with a dictionary
## to wich it should add necessary informations.
## [codeblock]
## static func serialize(target: ThisObjectsClass, data: Dictionary) -> SameDictionary:
##     # Do something
## [/codeblock]
var special_serialization: Callable
## A special function that will be called with a dictionary and an object
## to wich it should load necessary informations
## from the ones stored in the dictionary.
## [codeblock]
## static func deserialize(target: ThisObjectsClass, data: Dictionary) -> SameInstance:
##     # Do something
## [/codeblock]
var special_deserialization: Callable
## A JSONablizationInfo instance from wich infos are inherited.
var inherit: JSONablizationInfo:
	set(new):
		inherit = new
		inherit_depth = new.inherit_depth + 1
var inherit_depth: int = 0


func _init(_type: Object, _type_as_text: String, _attributes_to_save: Array[String] = []):
	type = _type
	type_as_text = _type_as_text
	attributes_to_save.append_array(_attributes_to_save)


## Optional special functions.
## See [member special_serialization] and [member special_deserialization].
## Returns self.
func set_special_serialization(serializer: Callable, deserializer: Callable) -> JSONablizationInfo:
	special_serialization = serializer
	special_deserialization = deserializer
	return self


## Set from wich [JSONablizationInfo] infos are inherited.
func set_inherit(new_inherit: JSONablizationInfo) -> JSONablizationInfo:
	inherit = new_inherit
	return self


## Calls [method set_inherit] with the [i]already built[/i] JSONablizationInfo
## wich has [param name] as [member type_as_text].
func set_inherit_by_name(name: StringName) -> JSONablizationInfo:
	for other_name in JSONablizationInfo.all:
		if other_name == name:
			set_inherit(JSONablizationInfo.all[other_name])
			return self
	assert(false, "No JSONablizationInfo for " + name)
	return self


func auto_inherit() -> JSONablizationInfo:
	var temp: Object = type.new()
	var best := JSONablizationInfo.get_most_precise(temp)
	
	if best:
		set_inherit(best)
	else:
		assert(false, "Unable to auto find from wich JSONablizationInfo this one inherit. - type: " + type_as_text)
	
	if not temp is RefCounted:
		temp.free()
	
	return self


## Build this JSONablizationInfo.
## [b]DO NOT MODIFY THIS INSTANCE AFTERWARD.[/b]
func build() -> JSONablizationInfo:
	JSONablizationInfo.all[type_as_text] = self
	return self


func get_consecutive_infos() -> Array[JSONablizationInfo]:
	var result: Array[JSONablizationInfo] = [self]
	
	while result[-1].inherit:
		result.push_back(result[-1].inherit)
	
	return result
