class_name Calculus
extends Note


## A note able to do calculations.
##
## When we speak about "variables" in this page, it's a dictionary with variable's
## names as keys and their values as values


## Emited when [member value] is changed.
signal value_changed(new: Variant, old: Variant)


## An array storing references to all alive Calculus
static var all: Array[WeakRef] = []

## Store script defined variables for expressions.
## If you want to get all variables for expressions, use [method get_all_variables]
static var default_variables: Dictionary = {}

## References to dictionaries that contains variables for expressions.
static var other_variables: Array[Dictionary] = []

## Callables returning dictionary of variables.
static var variable_getters: Array[Callable] = []

static var INT_REGEX: RegEx:
	get:
		if not INT_REGEX:
			INT_REGEX = RegEx.new()
			INT_REGEX.compile(r"(?<!\.|[a-zA-Z]|_)(-?\d+)(?!\.|[a-zA-Z]|_)")
		return INT_REGEX

## Return all variables defined for expressions.
## [br]Priority :
## [br] - [member variable_getters]
## [br] - [member other_variables]
## [br] - [member default_variables]
static func get_all_variables() -> Dictionary:
	var result: Dictionary = default_variables.duplicate()
	
	for variables in other_variables:
		result.merge(variables, true)
	
	for getter in variable_getters:
		result.merge(getter.call(), true)
	
	return result


static func ints_to_floats(expression: String) -> String:
	var matches: Array[RegExMatch] = INT_REGEX.search_all(expression)
	matches.reverse()
	
	for _match in matches:
		expression = (
			expression.substr(0, _match.get_end())
			+ ".0"
			+ expression.substr(_match.get_end())
		)
	
	return expression

## Stores an error representing the current error in the calculation.
var error: ErrorHelper

## [b]READONLY[/b]: The value of the current
var value: Variant:
	set(_new):
		var calculated: Variant = calculate()
		if calculated is ErrorHelper:
			error = calculated
			return
		error = null
		
		if typeof(calculated) == typeof(value) and calculated == value:
			return
		var old: Variant = value
		value = calculated
		value_changed.emit(calculated, old)


func _init(_title: String = "", _description: = "") -> void:
	title_changed.connect(update_value.unbind(2))
	Calculus.all.append(weakref(self))
	super(_title, _description)


func _notification(what: int) -> void:
	match what:
		NOTIFICATION_PREDELETE:
			for i in len(Calculus.all):
				if Calculus.all[i].get_ref() == self:
					Calculus.all.remove_at(i)
					break


func update_value() -> void:
	# Trigger setter
	value = null


## @deprecated Returns [member value]
func get_value() -> Variant:
	return value


func calculate(string_expression: String = title) -> Variant:
	if EasySettings.get_setting("notes/calculus/prevent_integer_division"):
		string_expression = Calculus.ints_to_floats(string_expression)
	
	var expression = Expression.new()
	
	var current_variables: Dictionary = Calculus.get_all_variables()
	var builtin_error: Error = expression.parse(string_expression, current_variables.keys())
	
	if builtin_error:
		var error_helper: ErrorHelper = ErrorHelper.new()
		error_helper.godot_builtin_error = builtin_error
		error_helper.description = translate_error_text(expression.get_error_text())
		return error_helper
	
	var result = expression.execute(
		current_variables.values(),
		CustomFunctions.singleton,
		OS.is_debug_build() and EasySettings.get_setting("debug/gdscript/show_expression_errors")
	)
	
	if expression.has_execute_failed():
		var error_helper: ErrorHelper = ErrorHelper.new()
		error_helper.description = translate_error_text(expression.get_error_text())
		return error_helper
	
	return result


class ErrorRegexes:
	static func create_regex(from_string: String) -> RegEx:
		var new_regex := RegEx.new()
		new_regex.compile(from_string)
		return new_regex
	
	static var undefined_variable := create_regex(r"Invalid named index '(?<variable_name>.*)'")


func translate_error_text(error_text: String) -> String:
	var regex_match: RegExMatch = ErrorRegexes.undefined_variable.search(error_text)
	if regex_match != null:
		return tr("ERROR_UNDEFINED_VARIABLE").format({
			&"variable_name": regex_match.get_string("variable_name")
		})
	
	return error_text
