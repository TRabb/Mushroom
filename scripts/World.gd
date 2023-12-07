extends Node2D

#Tilemap that contains my path
@onready var tileMap = $Path
#Path2D that is used to create a path for emeies to follow
@onready var path2D = $EnemyDirections
@onready var pathFollow2D = $EnemyDirections/PathFollow2D
@onready var button = $Button

#size of map - can measure 2d to get size in units
#length is +1 to the actual size of map to make path look like it goes off the map
@export var map_length:int = 41
@export var map_height:int = 18
@export var speed = 100

var _path:Array[Vector2i] = []

var _pg:PathGenerator

func _ready():                    
	_pg = PathGenerator.new(map_length, map_height)
	_display_path()
	_complete_grid()
	_create_curve2d()
	print(_pg.get_path())
	
	button.pressed.connect(self._button_pressed)
	
func _process(delta: float) -> void:
	pathFollow2D.progress += speed * delta
	
func _display_path():
	_path = _pg.generate_path()
	
	#builds out the path with the tilemap
	for element in _path:
		tileMap.set_cells_terrain_connect(0,_path,0,0,true)
		
#looks through every coordinate in the grid and fills any that are not a path with grass tileset		
func _complete_grid():
	for x in range(map_length):
		for y in range(map_height):
			if not _pg.get_path().has(Vector2i(x,y)):
				#holds the current coords of the tile that will be filled with grass
				var coords = Vector2i(x,y)
				tileMap.set_cell(0, coords, 2, Vector2i(0,0), 0)
	
func _create_curve2d():
	var _cleanX:int
	var _cleanY:int
	
	path2D.curve.clear_points()
	for coord in _pg.get_path():
		# need to clean so the enemies are in the middle of the path
		#coord value given by _path is the top left point of the box in the grid
		if coord.x == 0:
			_cleanX = coord.x
		else:
			_cleanX = (coord.x * 32) + 16
			
		_cleanY = (coord.y * 32) + 16
		path2D.curve.add_point(Vector2i(_cleanX,_cleanY))
		
func _button_pressed():
	print(get_tree().reload_current_scene())
	print("Scene Reloaded")
