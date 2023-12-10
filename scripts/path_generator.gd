#TO DO
# prevent long corridors - force change after a while
extends Node
class_name PathGenerator

var _path: Array[Vector2i]

const path_config:PathGeneratorConfig = preload("res://resources/basic_path_config.res")

#helper variables
var _rng = RandomNumberGenerator.new()
var counter:int = 0

func _init():
	generate_path()
	
func generate_path():
	randomize()
	#empty the current path array
	_path.clear()
	
	#path start position
	var x = -1
	var y = _rng.randi_range(0,17)
	
	#reset counter
	counter = 0
	var choice:int = randi_range(0,2)
	#start making path
	while x < path_config.map_length:
		
		if not _path.has(Vector2i(x,y)):
			_path.append(Vector2i(x,y))
		
		#force the path right for the first tile
		if counter == 0:
			choice = 0
		
		#75% chance to roll for a new path direction after the 3rd move in a direction
		if counter % 3 == 0 and not counter == 0:
			if _rng.randi_range(0,100) < 75:
				choice = randi_range(0,2)	
				
		#path goes right - x % 2 prevents creating turns with no gap
		if choice == 0 or x % 2 == 0:
			x += 1
		#path goes down - can not pick this if there is already a path down
		elif choice == 1 and y < (path_config.map_height - 1) and not _path.has(Vector2i(x,y+1)):
			y += 1
		#path goes up - can not pick this if there is already a path up
		elif choice == 2 and y > 2 and not _path.has(Vector2i(x,y-1)):
			y -= 1
		#if it cant go 	
		else:
			x +=1
		counter +=1
	return _path
	
func get_path_route() -> Array[Vector2i]:
	return _path

