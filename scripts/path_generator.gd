extends Object
class_name PathGenerator

var _grid_length:int
var _grid_height:int
var _path: Array[Vector2i]

var rng = RandomNumberGenerator.new()

func _init(length:int, height:int):
	_grid_length = length
	_grid_height = height
	
func generate_path():
	randomize()
	#empty the current path array
	_path.clear()
	
	#path start position
	var x = -1
	var y = rng.randi_range(0,21)

	#start making path
	while x < _grid_length:
		if not _path.has(Vector2i(x,y)):
			_path.append(Vector2i(x,y))
		
		var choice:int = randi_range(0,2)
		
		#path goes right
		if choice == 0 or x % 2 == 0:
			x += 1
		#path goes up
		elif choice == 1 and y < _grid_height:
			y += 1
		#path goes down		
		elif choice == 2 and y > 0:
			y -= 1
	return _path
	
#TO DO
#give path a default distance it must go before picking a direction
#	 ^^^^ variable that once > a certain number there is a % change the path goes a different direction
#do not allow path to go back on itself - array to remember which direction the path just went
