extends Path2D
var _cleanX:int
var _cleanY:int
var enemy_progress:float = 0

var speed = GameData.enemy_data["godot_enemy"]["speed"]
var hp = GameData.enemy_data["godot_enemy"]["hp"]

func _ready():
	self.curve = _path_route_to_curve_2D()
	$PathFollow2D.progress = 0
	
#region Pathing Methods
func _path_route_to_curve_2D() -> Curve2D:
	var curve_2D:Curve2D = Curve2D.new()

	for coord in PathGenInstance.get_path_route():
		if coord.x == 0:
			_cleanX = coord.x		
		else:
			_cleanX = (coord.x * 64) + 32
			
		_cleanY = (coord.y * 64) + 32
		curve_2D.add_point(Vector2i(_cleanX,_cleanY))
	return curve_2D
#endregion	

#region Hit Registration Methods
func on_hit(damage):
	hp -= damage
	print(hp)
	if hp <= 0:
		_on_destroy()
		
func _on_destroy():
	self.queue_free()
#endregion
	
#region State Methods
func _on_spawning_state_entered():
	#TODO: Add wave spawning logic here
	print("Spawn state")
	$StateChart.send_event("to_travelling")

func _on_travelling_state_entered():
	print("Travelling state")

func _on_travelling_state_processing(delta):
	var speed = 100
	enemy_progress += (delta * speed)
	$PathFollow2D.progress = enemy_progress
#endregion	

