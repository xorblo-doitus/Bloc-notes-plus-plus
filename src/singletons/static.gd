class_name ST

## Not truely a singleton, rather a class with static methods and variables
##
## Not all methods and variables are necessarily used, as some are coming
## from my own template.


## The inial width of the window, as stated in project settings.
## [br][i]Not updated on window resize.
static func get_screen_width() -> int:
	return ProjectSettings.get_setting("display/window/size/viewport_width")

## The inial height of the window, as stated in project settings.
## [br][i]Not updated on window resize.
static func get_screen_height() -> int:
	return ProjectSettings.get_setting("display/window/size/viewport_height")


## Return whether or not the [code]index[/code]'s bit of [code]mask[/code] is enabled.
static func is_bit_enabled(mask: int, index: int) -> int:
	return mask & (1 << index) == 1

## Return whether or not the [code]index[/code]-th bit of [code]mask[/code] is disabled.
static func is_bit_disabled(mask: int, index: int) -> int:
	return mask & (1 << index) == 0

## Enable the [code]index[/code]-th bit of [code]mask[/code].
## [br][i]Not in place.
func enable_bit(mask: int, index: int) -> int:
	return mask | (1 << index)

## Disable the [code]index[/code]-th bit of [code]mask[/code].
## [br][i]Not in place.
func disable_bit(mask: int, index: int) -> int:
	return mask & ~(1 << index)

## Return true if the [code]index[/code] is not out of [code]array[/code]'s range.
static func is_index_valid(array: Array, index: int) -> bool:
	return index < array.size() and index >= array.size() * -1


## Return the given [code]vector[/code] rotated to have the same direction as [code]target[/code].
static func align(vector: Vector2, target: Vector2) -> Vector2:
	return vector.rotated(vector.angle_to(target))


static func is_ref_valid(ref: WeakRef) -> bool:
	return ref.get_ref() != null


static var NOT_FOUND = Object.new():
	set(new): pass

## Returns the value associated to the type of the passed object,
## or the value associated with the closest ancestor.
static func dic_get_from_type(dictionary: Dictionary, object: Object, default = null) -> Object:
	var script_target: Script = object.get_script()
	var result = dictionary.get(script_target, NOT_FOUND)
	
	while result == NOT_FOUND and script_target.get_base_script():
		script_target = script_target.get_base_script()
		result = dictionary.get(script_target, NOT_FOUND)
	
	if result == NOT_FOUND:
		return default
	
	return result
