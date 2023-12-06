#TO DO
#give path a default distance it must go before picking a direction - feels pretty good right now
# require the first path generation to be to the right, since it starts at x=-1 potential for long path off screen
extends Object
class_name PathGenerator

var _grid_length:int
var _grid_height:int
var _path: Array[Vector2i]
var counter:int = 0

var _rng = RandomNumberGenerator.new()

func _init(length:int, height:int):
	_grid_length = length
	_grid_height = height
	
func generate_path():
	randomize()
	#empty the current path array
	_path.clear()
	
	#path start position
	var x = -1
	var y = _rng.randi_range(0,21)
	
	#reset counter
	counter = 0
	
	#start making path
	while x < _grid_length:
		
		if not _path.has(Vector2i(x,y)):
			_path.append(Vector2i(x,y))
		
		var choice:int = randi_range(0,2)
		
		#for path right for the first tile
		if counter == 0:
			choice = 0
			
		#path goes right - x % 2 prevents creating turns with no gap
		if choice == 0 or x % 2 == 0:
			x += 1
		#path goes down - can not pick this if there is already a path down
		elif choice == 1 and y < (_grid_height - 1) and not _path.has(Vector2i(x,y+1)):
			y += 1
		#path goes up - can not pick this if there is already a path up
		elif choice == 2 and y > 2 and not _path.has(Vector2i(x,y-1)):
			y -= 1
		#if it cant go 	
		else:
			x +=1
		counter +=1
	return _path
	
func get_path () -> Array[Vector2i]:
	return _path

