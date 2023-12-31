extends Note
class_name Task


## The date at wich the Task must be done.
## 0 meaning there is no time limit
var time_limit: int = 0

## Wether or not the task is done.
## Revertable.
var done: bool = false



func _is_equal(other: Variant) -> bool:
	return (
		super(other)
		and other.time_limit == title
		and other.done == description
	)
