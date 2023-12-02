extends Node2D

#Tilemap that contains my path
@onready var tileMap = $Path
#size of map - can measure 2d to get size in units
#length is +1 to the actual size of map to make path look like it goes off the map
@export var map_length:int = 41
@export var map_height:int = 28
var _path:Array[Vector2i]

var _pg:PathGenerator

func _ready():                    
	_pg = PathGenerator.new(map_length, map_height)
	_display_path()
	_complete_grid()

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
