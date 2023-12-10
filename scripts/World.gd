extends Node2D

var map_node
#variables for turrets
var build_mode = false
var build_valid = false
var build_location
var build_type
var tower_type
#Tilemap that will contain my path
@onready var tileMap = $Path
#Path2D that is used to create a path for emeies to follow
@onready var spawnEnemyButton = $UI/HUD/BuildBar/SpawnEnemy
@onready var generateNewMapButton = $UI/HUD/BuildBar/NewPath
@onready var buttonName

@export var basic_enemy:PackedScene

var _path:Array[Vector2i] = []


func _ready():         
	map_node = get_node("World")
	_display_path()
	_complete_grid()
	spawnEnemyButton.pressed.connect(self._spawn_button_pressed)
	generateNewMapButton.pressed.connect(self._map_button_pressed)
	
	for i in get_tree().get_nodes_in_group("build_buttons"):
		tower_type = i.get_name()
		i.pressed.connect(self._initiate_build_mode)

func _initiate_build_mode():
	build_type = tower_type
	build_mode = true
	get_node("UI").set_tower_preview(build_type, get_global_mouse_position())
	
func _process(delta):
	if build_mode:
		_update_tower_preview()
		
func _unhandled_input(event):
	#change mb_right and mb_left to better names
	if event.is_action_released("mb_right") and build_mode == true:
		cancel_build_mode()
	if event.is_action_released("mb_left") and build_mode == true:
		verify_build_mode()
		cancel_build_mode()
		
func verify_build_mode():
	if build_valid:
		var new_tower = load("res://scenes/Turret.tscn").instantiate()
		new_tower.position = build_location
		get_node("Turrets").add_child(new_tower,true)

func cancel_build_mode():
	build_mode = false
	build_valid = false
	get_node("UI/TowerPreview").queue_free()
		
func _update_tower_preview():
	var mouse_position = get_global_mouse_position()
	#x,y coord of tile
	var current_tile = tileMap.local_to_map(mouse_position)
	#position in pixels - this is top left
	var tile_position = tileMap.map_to_local(current_tile)
	
	#source id = 0 means path
	#source id = 2 means grass
	print(tileMap.get_cell_source_id(0, current_tile,false))
	if tileMap.get_cell_source_id(0, current_tile,false) != 0:
		get_node("UI").update_tower_preview(tile_position, Color.hex(0xad54ff3c))
		build_valid = true
		build_location = tile_position
	else:
		get_node("UI").update_tower_preview(tile_position, Color.hex(0xadff4646))
		build_valid = false
		
func _display_path():
	_path = PathGenInstance.get_path_route()
	#builds out the path with the tilemap
	for element in _path:
		tileMap.set_cells_terrain_connect(0,_path,0,0,true)
		
#looks through every coordinate in the grid and fills any that are not a path with grass tileset		
func _complete_grid():
	for x in range(PathGenInstance.path_config.map_length):
		for y in range(PathGenInstance.path_config.map_height):
			if not PathGenInstance.get_path_route().has(Vector2i(x,y)):
				#holds the current coords of the tile that will be filled with grass
				var coords = Vector2i(x,y)
				tileMap.set_cell(0, coords, 2, Vector2i(0,0), 0)
				
#rename to _create_enemy_path	
func _spawn_enemy():
	var new_enemy = basic_enemy.instantiate()
	add_child(new_enemy)
		
func _spawn_button_pressed():
	print("Enemy Spawned")
	_spawn_enemy()
	
func _map_button_pressed():
	PathGenInstance.generate_path()
	print(get_tree().reload_current_scene())
	print("Scene Reloaded")
	
func _turret_button_pressed():
	pass



