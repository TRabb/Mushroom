extends CharacterBody2D
var _cleanX:int
var _cleanY:int
var enemy_progress:float = 0

func _ready():
	$Path2D.curve = path_route_to_curve_2D()
	$Path2D/PathFollow2D.progress = 0
	
func path_route_to_curve_2D() -> Curve2D:
	var curve_2D:Curve2D = Curve2D.new()
	#print(PathGenInstance.get_path_route())
	for coord in PathGenInstance.get_path_route():
		if coord.x == 0:
			_cleanX = coord.x		
		else:
			_cleanX = (coord.x * 64) + 32
			
		_cleanY = (coord.y * 64) + 32
		curve_2D.add_point(Vector2i(_cleanX,_cleanY))
	return curve_2D
	
func _on_spawning_state_entered():
	print("Spawn state")
	$StateChart.send_event("to_travelling")

func _on_travelling_state_entered():
	print("Travelling state")


func _on_travelling_state_processing(delta):
	var speed = 100
	enemy_progress += (delta * speed)
	$Path2D/PathFollow2D.progress = enemy_progress
