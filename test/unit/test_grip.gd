extends GutTest


func compare_polygons(got: PackedVector2Array, expected: PackedVector2Array, pol_i: int) -> void:
	var polygon_name: String = "polygon n°%s (%s)" % [pol_i, GripDropArea.Side.find_key(2**(pol_i))]
	assert_eq(
		len(got),
		len(expected),
		"There is not the same amount of point in the polygon n°%s" % polygon_name
	)
	
	for i in len(got):
		assert_true(
			got[i].is_equal_approx(expected[i]),
			"Got %s expected %s on point n°%s of %s" % [got[i], expected[i], i, polygon_name]
		)


func test_drop_area() -> void:
	var areas: Array[GripDropArea] = GripDropArea.get_areas(
		Rect2(Vector2.ZERO, Vector2.ONE),
		0b11111,
		0.5
	)
	
	
	assert_eq(
		len(areas),
		5,
		"A wrong amount of grip areas where created."
	)
	
	
	compare_polygons(
		areas[0].polygon,
		PackedVector2Array([
			Vector2(0.25, 0.25),
			Vector2(0.75, 0.25),
			Vector2(0.75, 0.75),
			Vector2(0.25, 0.75)
		]),
		0
	)
	
	
	compare_polygons(
		areas[1].polygon,
		PackedVector2Array([
			Vector2.ZERO,
			Vector2.RIGHT,
			Vector2(0.75, 0.25),
			Vector2(0.25, 0.25)
		]),
		1
	)
	
	compare_polygons(
		areas[2].polygon,
		PackedVector2Array([
			Vector2(0.75, 0.25),
			Vector2.RIGHT,
			Vector2.ONE,
			Vector2(0.75, 0.75)
		]),
		2
	)
	
	compare_polygons(
		areas[3].polygon,
		PackedVector2Array([
			Vector2(0.25, 0.75),
			Vector2(0.75, 0.75),
			Vector2.ONE,
			Vector2.DOWN
		]),
		3
	)
	
	compare_polygons(
		areas[4].polygon,
		PackedVector2Array([
			Vector2.ZERO,
			Vector2(0.25, 0.25),
			Vector2(0.25, 0.75),
			Vector2.DOWN
		]),
		4
	)
