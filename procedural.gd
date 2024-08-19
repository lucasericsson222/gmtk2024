extends Node2D

var floor_tile = Vector2i(3,5)
var number_of_rooms = 100

var max_room_position := Vector2(50, 40)
var max_room_size := Vector2i(9, 9)
var min_room_size := Vector2i(4, 4)
var max_retries = 100
var room_spacing = 6

@onready var tileset: TileMapLayer = $Tileset
var dungeon = Dungeon.new()

var zombie_scene = preload("res://scenes/zombie.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	dungeon.position = Vector2.ZERO
	dungeon.size = max_room_position
	
	create_child_dungeon(dungeon)
	tile_edges()
	
	var rooms = get_all_child_rooms(dungeon)
	
	var start_room = rooms[randi_range(0, rooms.size() - 1)]
	
	var zombie_instance = zombie_scene.instantiate()
	add_to_room_random_position(start_room, zombie_instance)

func add_to_room_random_position(room, instance):
	var random_x = randf_range(room.position.x, room.position.x + room.size.x)
	var random_y = randf_range(room.position.y, room.position.y + room.size.y)
	var in_room_pos = Vector2(random_x * 16, random_y * 16)
	instance.position = in_room_pos
	add_child(instance)

func create_child_dungeon(dungeon):
	if dungeon == null:
		return
	var direction = 0
	var split_position = randf_range(0.30, 0.70)
	var min_split_position = min(split_position, 1 - split_position)

	var fits_horizontal = dungeon.size.x * min_split_position > min_room_size.x + room_spacing
	var fits_vertical = dungeon.size.y * min_split_position > min_room_size.y + room_spacing
	if fits_horizontal:
		direction = 0
	if fits_vertical:
		direction = 1
	if fits_horizontal and fits_vertical:
		direction = randi_range(0, 1)
		
	if direction == 0:
		# horizontal
		if dungeon.size.x * min_split_position > min_room_size.x + room_spacing:
			dungeon.right = Dungeon.new()
			dungeon.right.position = dungeon.position
			dungeon.right.size = Vector2(dungeon.size.x * split_position, dungeon.size.y)
			dungeon.left = Dungeon.new()
			dungeon.left.position = dungeon.position + Vector2(dungeon.size.x * split_position, 0)
			dungeon.left.size = Vector2(dungeon.size.x * (1 - split_position), dungeon.size.y)
	if direction == 1:
		if dungeon.size.y * min_split_position > min_room_size.y + room_spacing:
			dungeon.right = Dungeon.new()
			dungeon.right.position = dungeon.position
			dungeon.right.size = Vector2(dungeon.size.x, dungeon.size.y * split_position)
			dungeon.left = Dungeon.new()
			dungeon.left.position = dungeon.position + Vector2(0 , dungeon.size.y * split_position)
			dungeon.left.size = Vector2(dungeon.size.x, dungeon.size.y * (1 - split_position))
	create_child_dungeon(dungeon.left)
	create_child_dungeon(dungeon.right)
	
	if dungeon.left == null:
		var size = Vector2.ZERO
		size.x = randi_range(min_room_size.x, dungeon.size.x - room_spacing)
		size.y = randi_range(min_room_size.y, dungeon.size.y - room_spacing)
		var position_relative = Vector2.ZERO
		position_relative.x = randi_range(room_spacing / 2, dungeon.size.x - size.x - room_spacing / 2)
		position_relative.y = randi_range(room_spacing / 2, dungeon.size.y - size.y - room_spacing / 2)
		var room = Room.new()
		room.position = position_relative + dungeon.position
		room.size = size
		tile_room(position_relative + dungeon.position, size)
		dungeon.room = room
	
	if dungeon.left != null:
		
		var left = get_all_child_rooms(dungeon.left)
		var right = get_all_child_rooms(dungeon.right)
		connect_rooms(left, right)
	
func connect_rooms(left_rooms, right_rooms):
	var room_left_index = randi_range(0, left_rooms.size() - 1)
	var room_right_index = randi_range(0, right_rooms.size() - 1)
	
	var left_room = left_rooms[room_left_index]
	var right_room = right_rooms[room_right_index]
	create_path(get_room_center(left_room), get_room_center(right_room))

func create_path(left: Vector2i, right: Vector2i):
	
	var min_x = min(left.x, right.x)
	var min_y = min(left.y, right.y)
	var max_x = max(left.x, right.x)
	var max_y = max(left.y, right.y)
	
	for i in range(min_x, max_x):
		set_tile(i, min_y, floor_tile)
	for j in range(min_y, max_y):
		set_tile(max_x, j, floor_tile)
	
func get_room_center(room:Room):
	return room.size / 2 + room.position
	
func get_all_child_rooms(dungeon) -> Array[Room]:
	var rooms: Array[Room] = []
	if dungeon == null:
		return rooms
	if dungeon.room != null:
		rooms.append(dungeon.room)
	
	rooms.append_array(get_all_child_rooms(dungeon.left))
	rooms.append_array(get_all_child_rooms(dungeon.right))
	return rooms
	
func _draw() -> void:
	#draw_dungeon(dungeon)
	pass
	
func draw_dungeon(dungeon: Dungeon):
	if dungeon == null:
		return
	if dungeon.left == null:
		draw_rect(Rect2(dungeon.position * 16, dungeon.size * 16), Color.WHITE, false)
	draw_dungeon(dungeon.left)
	draw_dungeon(dungeon.right)
func random_room():
	var new_room = Room.new()
	new_room.position.x = randi_range(0, max_room_position.x)
	new_room.position.y = randi_range(0, max_room_position.y)
	new_room.size.x = randi_range(5, max_room_size.x)
	new_room.size.y = randi_range(5, max_room_size.y)
	return new_room
	
func tile_edges():
	for i in range(-1, max_room_position.x + max_room_size.x):
		for j in range(-1, max_room_position.y + max_room_size.y):
			if is_floor_tile(i,j):
				continue
			var num_edges = 0
			if is_floor_tile(i + 1, j):
				set_tile(i, j, Vector2i(2, 5))
				num_edges += 1
			if is_floor_tile(i - 1, j):
				set_tile(i, j, Vector2i(4, 5))
				num_edges += 1
			if is_floor_tile(i , j + 1):
				set_tile(i, j, Vector2i(3, 4))
				num_edges += 1
			if is_floor_tile(i, j - 1):
				set_tile(i, j, Vector2i(3, 11))
				num_edges += 1
			if num_edges == 0:
				if is_floor_tile(i - 1, j + 1):
					set_tile(i, j, Vector2i(4, 4))
				if is_floor_tile(i + 1, j + 1):
					set_tile(i, j, Vector2i(2, 4))
				if is_floor_tile(i - 1, j - 1):
					set_tile(i, j, Vector2i(4, 11))
				if is_floor_tile(i + 1, j - 1):
					set_tile(i, j, Vector2i(2, 11))
			if num_edges == 2:
				if is_floor_tile(i + 1, j + 1) and is_floor_tile(i + 1, j) and is_floor_tile(i, j + 1):
					set_tile(i, j, Vector2(2, 7))
				if is_floor_tile(i - 1, j + 1) and is_floor_tile(i - 1, j) and is_floor_tile(i, j + 1):
					set_tile(i, j, Vector2i(4, 7))
				if is_floor_tile(i + 1, j - 1) and is_floor_tile(i + 1, j) and is_floor_tile(i, j - 1):
					set_tile(i, j, Vector2i(2, 9))
				if is_floor_tile(i - 1, j - 1) and is_floor_tile(i - 1, j) and is_floor_tile(i, j - 1):
					set_tile(i, j, Vector2i(4, 9))
			if num_edges > 2:
				set_tile(i, j, floor_tile)
	for i in range(-1, max_room_position.x + max_room_size.x):
		for j in range(-1, max_room_position.y + max_room_size.y):
			if get_tile(i, j) == Vector2i(4, 4):
				set_tile(i, j - 1, Vector2i(4, 3))
			if get_tile(i, j) == Vector2i(2, 4):
				set_tile(i, j - 1, Vector2i(2, 3))
			if get_tile(i, j) == Vector2i(3, 4):
				set_tile(i, j - 1, Vector2i(3, 3))
			if get_tile(i, j) == Vector2i(2, 7):
				set_tile(i, j - 1, Vector2i(2, 6))
			if get_tile(i, j) == Vector2i(4, 7):
				set_tile(i, j - 1, Vector2i(4, 6))
				
func is_floor_tile(i, j) -> bool:
	var tile = get_tile(i, j)
	if tile == null:
		return false;
	return tile == floor_tile

func set_tile(i, j, tile: Vector2i):
	$Tileset.set_cell(Vector2i(i, j), 1, tile)

func get_tile(i, j):
	return tileset.get_cell_atlas_coords(Vector2i(i , j))


func are_sets_overlapping(x1, x2, y1, y2) -> bool:
	return x2 >= y1 && x1 <= y2

func tile_room(pos: Vector2i, size: Vector2i):
	var max_x = size.x
	var max_y = size.y
	for i in range(0, size.x):
		for j in range(0, size.y):
			var tile_to_set = Vector2i.ZERO
			#if i == 0 and j == 0:
			#	tile_to_set = Vector2i(2, 3)
			#elif i == 0 and j == 1:
			#	tile_to_set = Vector2i(2, 4)
			#elif i == max_x - 1 and j == 0:
			#	tile_to_set = Vector2i(4, 3)
			#elif i == max_x - 1 and j == 1:
			#	tile_to_set = Vector2i(4, 4)
			#elif i == 0 and j == max_y - 1:
			#	tile_to_set = Vector2i(2, 11)
			#elif i == max_x -1 and j == max_y - 1:
			#	tile_to_set = Vector2i(4, 11)
			#elif j == 0:
			#	tile_to_set = Vector2i(3, 3)
			#elif j == 1:
			#	tile_to_set = Vector2i(3, 4)
			#elif i == 0:
			#	tile_to_set = Vector2i(2, 5)
			#elif i == max_x - 1:
			#	tile_to_set = Vector2i(4, 5)
			#elif j == max_y - 1:
			#	tile_to_set = Vector2i(3, 11)
			
			tile_to_set = floor_tile
			$Tileset.set_cell(Vector2i(pos.x + i, pos.y + j), 1, tile_to_set)
