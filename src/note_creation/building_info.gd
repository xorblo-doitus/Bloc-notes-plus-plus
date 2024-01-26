class_name BuildingInfo
extends RefCounted


## All informations a [Builder] need to know about the type of note it is creating.


## Static variable storing informations about how to create notes.
## Keys are the type as [Script]. See also [member all_from_string].
static var all: Dictionary = {}


static func get_most_precise(for_type: Object) -> BuildingInfo:
	var result: BuildingInfo = ST.dic_get_from_type(
		BuildingInfo.all,
		for_type
	)
	
	if result == null:
		assert(false, "No BuildingInfo for " + str(for_type))
	
	return result



## The class of the object to store. ([Note], [Variable]...)
var type: Object

## The class of the object to store. ([Note], [Variable]...)
var type_translation_key: String

## A list of attributes to save
var attributes_to_edit: Array[String] = []

## A list of [WidgetEdit] as [PackedScene]
var widget_edits: Array[PackedScene] = []

## If not specified, use [member type][code].new()[/code].
## Else new instances will be created using this function. Exemple:
## [codeblock]
## static func instantiate() -> ThisObjectsClass:
##     var new: ThisObjectsClass = preload("path/ti/scene").instantiate()
##     new.some_attribute = "initial_value"
##     return new
## [/codeblock]
var instantiating_function: Callable:
	get:
		if instantiating_function:
			return instantiating_function
		
		return type.new


## A BuildingInfo instance from wich infos are inherited.
var inherit: BuildingInfo:
	set(new):
		inherit = new


func _init(_type: Object) -> void:
	type = _type


## Set [member instantiating_function].
## Chainable. 
func set_instantiating_function(function: Callable) -> BuildingInfo:
	instantiating_function = function
	return self


## Set from wich [BuildingInfo] infos are inherited.
func set_inherit(new_inherit: BuildingInfo) -> BuildingInfo:
	inherit = new_inherit
	return self


## Needs type and instantiating function to be at their final value.
func auto_setup_from_JSONablization_info() -> BuildingInfo:
	var fetched: JSONablizationInfo = JSONablizationInfo.get_most_precise(instantiating_function.call())
	
	attributes_to_edit = fetched.attributes_to_save
	if fetched.instantiating_function != instantiating_function:
		instantiating_function = fetched.instantiating_function
	
	var ancestor = fetched
	while ancestor.inherit:
		if BuildingInfo.all.has(ancestor.inherit.type):
			inherit = BuildingInfo.all.get(ancestor.inherit.type)
			break
		ancestor = ancestor.inherit
	
	return self


func set_type_translation_key(_type_translation_key: String) -> BuildingInfo:
	type_translation_key = _type_translation_key
	return self


func set_widget_edits(_widget_edits: Array[PackedScene]) -> BuildingInfo:
	widget_edits = _widget_edits
	return self


## Build this BuildingInfo.
## [b]DO NOT MODIFY THIS INSTANCE AFTERWARD.[/b]
func build() -> BuildingInfo:
	BuildingInfo.all[type] = self
	return self


func get_consecutive_infos() -> Array[BuildingInfo]:
	var result: Array[BuildingInfo] = [self]
	
	while result[-1].inherit:
		result.push_back(result[-1].inherit)
	
	return result
