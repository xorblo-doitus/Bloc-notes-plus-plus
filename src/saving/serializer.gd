extends Object
class_name Serializer

## Let serialize Objects
## 
## Search for an [code]attributes_to_serialize[/code] constant in objects
## to serialize them or a [code]special_JSONablization[/code] method
## wich should append special data to the [Dictionary] passed as argument to it.



## Turns anything into a loadable string
static func serialize(target: Variant) -> String:
	return JSON.stringify(JSONablize(target))


const deserialize_errors: Dictionary = {
	48: "How was the Easter-Egg Error fired ???"
}


## Loads a JSON string as anything
static func deserialize(text: String) -> Variant:
	var json: JSON = JSON.new()
	var error := json.parse(text)
	if error:
		var formated_error: Error = Error.new()
		formated_error.title = "Error %s while deserializing the following text:" % error
		formated_error.title += text
		formated_error.description = str(error) + ": " + deserialize_errors.get(error, "No specific error message")
		return Error
	
	return json.data



## All types that can be handled automatically by Godot's JSON class.
const JSONable = [
	TYPE_STRING,
	TYPE_STRING_NAME,
	TYPE_INT,
	TYPE_FLOAT,
	TYPE_BOOL,
]


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
			
		var _type when _type in JSONable:
			return target
	
	assert(false, "Unable to JSONablize {target}.".format({
		"target": target
	}))
	
	return null


#static func is_instance_of(obj:Object, given_class_name:String) -> bool:
	#if ClassDB.class_exists(given_class_name):
		#return obj.is_class(given_class_name)
	#else:
		## We don't have a build in class
		## It must be a script class
		#var class_script:Script
		## Assume it is a script path and try to load it
		#if ResourceLoader.exists(given_class_name):
			#class_script = load(given_class_name) as Script
#
		#if class_script == null:
			## Assume it is a class name and try to find it
			#for x in ProjectSettings.get_setting("_global_script_classes"):
				#if str(x["class"]) == obj_class_name:
					#class_script = load(str(x["path"]))
					#break
#
		#if class_script == null:
			## Unknown class
			#return false
#
		## Get the script of the object and try to match it
		#var check_script := obj.get_script()
		#while check_script != null:
			#if check_script == class_script:
				#return true
#
			#check_script = check_script.get_base_script()
#
		## Match not found
		#return false

#static func find_class(object: Object) -> String:
	##var script_path = object.get_script().resource_path
	##for class_info in ProjectSettings.get_global_class_list():
		##if class_info.path == 
	#var matching: Array[Dictionary] = []
	#for class_info in JSONablizationInfo.all.values():
		#if is_instance_of(object, (class_info.type)):
			#matching.push_back(class_info)
	#
	#return ""


## Turns [param target] into a JSONable dictionary.
static func JSONablize_object(target: Object) -> Dictionary:
	var data: Dictionary = {}
	var infos: Array[JSONablizationInfo] = JSONablizationInfo.get_most_precise(
				target).get_consecutive_infos()
	
	data[&"type"] = infos[0].type_as_text
	
	for info in infos:
		for attribute_to_save in info.attributes_to_save:
			data[attribute_to_save] = target.get(attribute_to_save)
		
		if info.special_load != null:
			info.special_load.call(target, data)
	
	if data.is_empty():
		assert(false, "Unable to JSONablize {target}.".format({
			"target": target
		}))
	
	return data
