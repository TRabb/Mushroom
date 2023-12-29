extends Node2D

var map_node
#variables for turrets
var build_mode = false
var build_valid = false
var build_location
var build_type
var tower_type
var current_wave = 0
var enemies_in_wave = 0
#Tilemap that will contain my path
@onready var tileMap = $Path
#Path2D that is used to create a path for emeies to follow
@onready var spawnEnemyButton = $UI/HUD/ButtonBar/SpawnEnemy
@onready var generateNewMapButton = $UI/HUD/ButtonBar/NewPath
@onready var buildBar = $UI/HUD/BuildBar


var _path:Array[Vector2i] = []

func _ready():
	#gets a fresh scene every time it is switched too
	#GameData.duplicate(true())
	reload_game()
	#TODO: Add a tooltip that shows the towers stats when you hover over the tower build button
	spawnEnemyButton.pressed.connect(self._spawn_button_pressed)
	generateNewMapButton.pressed.connect(self._map_button_pressed)
	
	#allows each turret texturebutton in the build_buttons group to be clicked
	for i in get_tree().get_nodes_in_group("build_buttons"):
		i.pressed.connect(self._initiate_build_mode.bind(i.get_name()))
	
func _process(delta):
	get_node("UI").update_health_display()
	if build_mode:
		_get_tower_preview()
	get_node("UI").update_money_display()
	_player_level_up()

		
func _unhandled_input(event):
	#change mb_right and mb_left to better names
	if event.is_action_released("mb_right"):
			_cancel_build_mode()
	if event.is_action_released("mb_left"):
			if _has_enough_money() == true:
				_place_tower()		
		
#region Building Methods#
func _get_tower_preview():
	var mouse_position = get_global_mouse_position()
	#x,y coord of tile
	var current_tile = tileMap.local_to_map(mouse_position)
	#position in pixels - this is top left
	var tile_position = tileMap.map_to_local(current_tile)
	
	#source id = 1 means path
	#source id = 5 means grass
	#source id = 3 means no_build
	#print(tileMap.get_cell_source_id(0, current_tile,false))
	
	#if the cell is not a path - change the sprite to be slightly see through
	if _valid_build_location() == true:
		get_node("UI").update_tower_preview(tile_position, Color.hex(0xad54ff3c))
		build_valid = true
		build_location = tile_position
	#if the cell is a path - grey out the sprite
	else:
		get_node("UI").update_tower_preview(tile_position, Color.hex(0x3d3d3d))
		build_valid = false
		
func _initiate_build_mode(tower_type):
	if build_mode:
		_cancel_build_mode()
	build_type = tower_type
	build_mode = true
	get_node("UI").set_tower_preview(build_type, get_global_mouse_position())

func _place_tower():
	#mouse position in (px coordiates)
	#map_to_local will give x,y coordinates
	var mouse_position = tileMap.local_to_map(get_global_mouse_position())
	
	#build must be valid and inside of the map
	if build_valid:
		var new_tower = load("res://scenes/defenses/" + build_type + ".tscn").instantiate()
		new_tower.position = build_location
		new_tower.type = build_type
		new_tower.built = true
		get_node("Turrets").add_child(new_tower,true)
		#set the tile behind the sprite to no_build - this is used to prevent building towers on top of eachother
		tileMap.set_cell(0, Vector2i(tileMap.local_to_map(build_location)), 3, Vector2i(0,0), 0)
		print("Tower Placed")
		#print("Build location: " + str(tileMap.local_to_map(build_location)))
		#print("NoBuild tile location: " + str(mouse_position))
		GameData.player_data["player"]["money"] -= GameData.tower_data[build_type]["cost"]
		_cancel_build_mode()	
	else:
		_cancel_build_mode()

func _cancel_build_mode():
	build_mode = false
	build_valid = false
	if get_node_or_null("UI/TowerPreview") != null:
		get_node("UI/TowerPreview").free()
		print("Build Mode Canceled")
	
func _valid_build_location():
	var mouse_position = tileMap.local_to_map(get_global_mouse_position())
	
	#basic validation that any tower will follow
	#tile is not a path
	if tileMap.get_cell_source_id(0, mouse_position,false) != 0:
		#tile is not already built on
		if tileMap.get_cell_source_id(0, mouse_position,false) != 3:
			#tile is within the map
			if mouse_position.y < PathGenInstance.path_config.map_height:
				return true
	else:
		return false
		
#check if user has enough money to build the selected turret	
func _has_enough_money():
	var currentMoney = GameData.player_data["player"]["money"]
	if build_type != null:
		var towerCost = GameData.tower_data[build_type]["cost"]
		if currentMoney < towerCost:
			print("Player does not have enough money")
			_cancel_build_mode()
			return false
		elif currentMoney >= towerCost:
			print("Player has enough money")
			return true
		elif currentMoney <= 0:
			print("Player does not have enough money")
			_cancel_build_mode()
			return false


#endregion#

#region Map Generation Methods#
func _display_path():
	_path = PathGenInstance.get_path_route()
	#builds out the path with the tilemap
	for element in _path:
		#print(tileMap.map_to_local(element))
		tileMap.set_cells_terrain_connect(0,_path,0,0,true)
	
#looks through every coordinate in the grid and fills any that are not a path with grass tileset		
func _complete_grid():

	for x in range(PathGenInstance.path_config.map_length):
		for y in range(PathGenInstance.path_config.map_height):
			if not PathGenInstance.get_path_route().has(Vector2i(x,y)):
				#holds the current coords of the tile that will be filled with grass
				var coords = Vector2i(x,y)
				tileMap.set_cell(0, coords, 5, Vector2i(0,0), 0)	
#endregion#	

#region Button Methods#
func _map_button_pressed():
	PathGenInstance.generate_path()
	get_tree().reload_current_scene()
	print("Scene Reloaded")
	GameData.reset()
	
func _spawn_button_pressed():
	_start_next_wave()
	pass
#endregion#

#region Enemy/Wave Methods#
#adds an enemy to the path 			
func _spawn_enemies(wave_data):
	#FIXME: MAYBE - Find solution to add each enemy to a single Path2D
	#this will spawn enemy by scene name. each scene needs a corresponding script
	for i in wave_data:
		var new_enemy = load("res://scenes/enemies/"+ i[0] +".tscn").instantiate()
		add_child(new_enemy)
		await(get_tree().create_timer(i[1]).timeout)
		print(i[0] + " Spawned")
	
func _start_next_wave():
	var wave_data = _retrieve_wave_data()
	await(get_tree().create_timer(0.2).timeout)
	_spawn_enemies(wave_data)
	
func _retrieve_wave_data():
	#TODO: Build out waves
	#TODO: Pause/Unpause waves - user should still be able to build during this
	#first value is the enemy to spawn, second value is the delay before spawning next enemy in array
	var wave_data:Array = [["farmer_enemy", 1], ["farmer_enemy", 1]]
	current_wave += 1
	enemies_in_wave = wave_data.size()
	return wave_data
#endregion



#region Utility Methods
func reload_game():
	PathGenInstance.generate_path()
	_display_path()
	_complete_grid()
	#reset() just resets the player dictionary to default values
	GameData.reset()

func is_player_dead():
	if GameData.player_data["player"]["health"] <= 0:
		get_tree().paused = true
		var youLost = load("res://scenes/menus/YouLosePopup.tscn")
		get_node("UI").add_child(youLost.instantiate())
		
func _player_level_up():
	if GameData.player_data["player"]["xp"] >= GameData.player_data["player"]["xp_to_level"]:
		GameData.player_data["player"]["current_level"] += 1
		GameData.player_data["player"]["xp"] = GameData.player_data["player"]["xp"] - GameData.player_data["player"]["xp_to_level"]
		#use snapped method for rounding decimals
		GameData.player_data["player"]["xp_to_level"] = snapped(GameData.player_data["player"]["xp_to_level"] * 1.3, 1)
		get_node("UI").update_xp_bar()
		get_node("UI").update_playerLevel_display()
		
		_get_levelUp_screen()
		
	else:
		get_node("UI").update_xp_bar()
		get_node("UI").update_playerLevel_display()
		
func _get_levelUp_screen():
	#TODO: Level up logic
	get_tree().paused = true
	var levelUp = load("res://scenes/menus/LevelUpPopup.tscn")
	get_node("UI").add_child(levelUp.instantiate())		
#endregion





