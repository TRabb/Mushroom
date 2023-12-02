extends Node2D

#Tilemap that contains my path
@onready var tileMap = $TileMap
#size of map - can measure 2d to get size in units
#length is +1 to the actual size of map to make path look like it goes off the map
@export var map_length:int = 41
@export var map_height:int = 20

var _pg:PathGenerator

func _ready():                    
	_pg = PathGenerator.new(map_length, map_height)
	_display_path()

func _display_path():
	var _path:Array[Vector2i] = _pg.generate_path()
	
	for element in _path:
		tileMap.set_cells_terrain_connect(0,_path,0,0,true)
