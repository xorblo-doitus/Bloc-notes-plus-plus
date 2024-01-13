extends GutTest


func compare_polygons(areas_got: Array[GripDropArea], pol_i: int, expected: PackedVector2Array) -> void:
	var side: GripDropArea.Side = areas_got[pol_i].side
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


func compare_areas(areas: Array[GripDropArea], expected_polygons: Array[PackedVector2Array]) -> void:
	assert_eq(
		len(areas),
		len(expected_polygons),
		"A wrong amount of grip areas where created."
	)
	
	
	for i in len(areas):
		compare_polygons(
			areas,
			i,
			expected_polygons[i],
		)
	
	
	for area in areas:
		area.free()


func test_drop_area_base() -> void:
	var areas: Array[GripDropArea] = GripDropArea.get_areas(
		Rect2(Vector2.ZERO, Vector2.ONE),
		GripDropArea.ALL_SIDES,
		0.5
	)
	
	compare_areas(areas, [
		[
			Vector2(0.25, 0.25),
			Vector2(0.75, 0.25),
			Vector2(0.75, 0.75),
			Vector2(0.25, 0.75)
		],
		[
			Vector2.ZERO,
			Vector2.RIGHT,
			Vector2(0.75, 0.25),
			Vector2(0.25, 0.25)
		],
		[
			Vector2(0.75, 0.25),
			Vector2.RIGHT,
			Vector2.ONE,
			Vector2(0.75, 0.75)
		],
		[
			Vector2(0.25, 0.75),
			Vector2(0.75, 0.75),
			Vector2.ONE,
			Vector2.DOWN
		],
		[
			Vector2.ZERO,
			Vector2(0.25, 0.25),
			Vector2(0.25, 0.75),
			Vector2.DOWN
		],
	])
	

func test_drop_area_column() -> void:
	var areas: Array[GripDropArea] = GripDropArea.get_areas(
		Rect2(Vector2.ZERO, Vector2.ONE),
		GripDropArea.COLUMN,
		0.5
	)
	
	compare_areas(areas, [
		[
			Vector2(0, 0.25),
			Vector2(1, 0.25),
			Vector2(1, 0.75),
			Vector2(0, 0.75)
		],
		[
			Vector2.ZERO,
			Vector2.RIGHT,
			Vector2(1, 0.25),
			Vector2(0, 0.25)
		],
		[
			Vector2(0, 0.75),
			Vector2(1, 0.75),
			Vector2.ONE,
			Vector2.DOWN
		],
	])


func test_no_center() -> void:
	var areas: Array[GripDropArea] = GripDropArea.get_areas(
		Rect2(Vector2.ZERO, Vector2.ONE),
		0b0101_0,
		0.5
	)
	
	compare_areas(areas, [
		[
			Vector2.ZERO,
			Vector2.RIGHT,
			Vector2(1, 0.5),
			Vector2(0, 0.5)
		],
		[
			Vector2(0, 0.5),
			Vector2(1, 0.5),
			Vector2.ONE,
			Vector2.DOWN
		],
	])
