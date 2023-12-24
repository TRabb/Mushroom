extends Path2D
var _cleanX:int
var _cleanY:int
var enemy_progress:float = 0

#enemy stats
var speed = GameData.enemy_data["farmer_enemy"]["speed"]
var hp = GameData.enemy_data["farmer_enemy"]["hp"]
var reward = GameData.enemy_data["farmer_enemy"]["reward"]
var damage = GameData.enemy_data["farmer_enemy"]["damage"]

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
			_cleanX = (coord.x * 128) + 64
			
		_cleanY = (coord.y * 128) + 64
		curve_2D.add_point(Vector2i(_cleanX,_cleanY))
	return curve_2D
#endregion	

#region Hit Registration Methods
func on_hit(damage):
	hp -= damage
	print("godot_enemy hp: " + str(hp))
	if hp <= 0:
		_on_destroy()
		
func _on_destroy():
	self.queue_free()
	GameData.player_data["player"]["money"] += reward
	
func _on_survived():
	self.queue_free()
	GameData.player_data["player"]["health"] -= damage

func current_position():
	#print("Enemy global position: " + str($PathFollow2D.position/2))
	return $PathFollow2D.position/2
#endregion
	
#region State Methods
func _on_spawning_state_entered():
	print("Spawn state")
	$StateChart.send_event("to_travelling")

func _on_travelling_state_entered():
	print("Travelling state")

func _on_travelling_state_processing(delta):
	enemy_progress += (delta * speed)
	$PathFollow2D.progress = enemy_progress
	if $PathFollow2D.progress_ratio == 1:
		_on_survived()
#endregion	

