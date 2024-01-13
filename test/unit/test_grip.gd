extends GutTest


func compare_polygons(areas_got: Array[GripDropArea], pol_i: int, expected: PackedVector2Array, side = 2**(pol_i)) -> void:
	var polygon_name: String = "polygon n°%s (%s)" % [pol_i, GripDropArea.Side.find_key(side)]
	var got = areas_got[pol_i].polygon
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


func test_drop_area_base() -> void:
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
		areas,
		0,
		PackedVector2Array([
			Vector2(0.25, 0.25),
			Vector2(0.75, 0.25),
			Vector2(0.75, 0.75),
			Vector2(0.25, 0.75)
		]),
	)
	
	
	compare_polygons(
		areas,
		1,
		PackedVector2Array([
			Vector2.ZERO,
			Vector2.RIGHT,
			Vector2(0.75, 0.25),
			Vector2(0.25, 0.25)
		]),
	)
	
	compare_polygons(
		areas,
		2,
		PackedVector2Array([
			Vector2(0.75, 0.25),
			Vector2.RIGHT,
			Vector2.ONE,
			Vector2(0.75, 0.75)
		]),
	)
	
	compare_polygons(
		areas,
		3,
		PackedVector2Array([
			Vector2(0.25, 0.75),
			Vector2(0.75, 0.75),
			Vector2.ONE,
			Vector2.DOWN
		]),
	)
	
	compare_polygons(
		areas,
		4,
		PackedVector2Array([
			Vector2.ZERO,
			Vector2(0.25, 0.25),
			Vector2(0.25, 0.75),
			Vector2.DOWN
		]),
	)
	
	for area in areas:
		area.free()
