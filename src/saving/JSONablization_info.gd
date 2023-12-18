extends RefCounted
class_name JSONablizationInfo


## Static variable storing inforamations about how to [method JSONablize]
## and read JSONabled [Object]s
static var all: Dictionary = {}

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


## Build this JSONablizationInfo.
## [b]DO NOT USE THIS INSTANCE AFTERWARD[/b]
#func build():
	#for already_existing in all:
		#if already_existing.type is 
		#JSONablization[type_as_text] = self
