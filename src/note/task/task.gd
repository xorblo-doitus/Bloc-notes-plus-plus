class_name Task
extends Note


## Wether or not the task is done.
## Revertable.
var done: bool = false



func _is_equal(other: Variant) -> bool:
	return (
		super(other)
		and other.time_limit == title
		and other.done == description
	)
