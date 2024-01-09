class_name Calculus
extends Note


## A note able to do calculations.
##
## When we speak about "variables" in this page, it's a dictionary with variable's
## names as keys and their values as values


## Store script defined variables for expressions.
## If you want to get all variables for expressions, use [method get_all_variables]
static var default_variables: Dictionary = {}

## References to dictionaries that contains variables for expressions.
static var other_variables: Array[Dictionary] = []

## Callables returning dictionary of variables.
static var variable_getters: Array[Callable] = []

## Return all variables defined for expressions.
## [br]Priority :
## [br] - [member variable_getters]
## [br] - [member other_variables]
## [br] - [member default_variables]
func get_all_variables() -> Dictionary:
	var result: Dictionary = default_variables.duplicate()
	
	for variables in other_variables:
		result.merge(variables, true)
	
	for getter in variable_getters:
		result.merge(getter.call(), true)
	
	return result


func _init():
	pass # Replace with function body.


func get_value() -> float:
	var current_variables: Dictionary = get_all_variables()
	var expression = Expression.new()
	expression.parse(title, current_variables.keys())
	var result = expression.execute(current_variables.keys())
	return result
