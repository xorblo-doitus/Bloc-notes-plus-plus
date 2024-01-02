extends Note
class_name Calculus

func _init():
	pass # Replace with function body.

func get_value() -> float:
	var expression = Expression.new()
	expression.parse(title)
	var result = expression.execute()
	return result
