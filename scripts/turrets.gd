extends Node

var type
var enemy_array:Array = []
var built = false
var enemy
var readytofire= true
var bullet


func _ready():
	if built:
		self.get_node("Range/CollisionShape2D").get_shape().radius = .5 * GameData.tower_data[type]["range"]

func _physics_process(delta):
	if enemy_array.size() != 0 and built:
		_select_enemy()
		#check to see if the bullet collision box and enemy collision box hit. if so, deal damage
		if bullet != null and bullet.enemy_hit():
			var enemy_hit_id = bullet.get_enemy_id()
			#gets the instance of the path2d from the id of the character2d collisionbox
			if instance_from_id(enemy_hit_id) != null:
				#FIXME: Find solution for bullets sitting on screen after collision. Happens when there are a lot of bullets in queue
				bullet.queue_free()
				var enemy_hit = instance_from_id(enemy_hit_id).get_parent().get_parent()
			#path2d is required to use the functions within the enemy scripts
				if enemy_hit is Path2D:
					enemy_hit.on_hit(GameData.tower_data[type]["damage"])
			else:
				print("Enemy is dead")
		if readytofire:
			_fire()
	else:
		enemy = null	

#region Turret Range Methods
func _on_range_body_entered(body):
	#check required so nodes in the Bullet group are not added to the enemy array
	if not body.is_in_group("Bullet"):
		enemy_array.append(body.get_parent())

func _on_range_body_exited(body):
	enemy_array.erase(body.get_parent())
#endregion

#region Turret Shooting Methods
func _select_enemy():
	#select the enemy that has the furthest progress down the curve2d
	var enemy_progress_array = []
	for i in enemy_array:
		enemy_progress_array.append(i.get_progress())
	var max_progress = enemy_progress_array.max()
	var enemy_index = enemy_progress_array.find(max_progress)
	enemy = enemy_array[enemy_index]
	
func _create_bullet():
	#creates the bullet scene and targets at the enemy
	bullet = load("res://scenes/bullet.tscn").instantiate()
	self.get_parent().add_child(bullet)
	bullet.position = Vector2(self.position.x, self.position.y)
	var enemyPosition = enemy.current_position()
	bullet.set_velocity(enemyPosition - bullet.position)
	
func _fire():
	readytofire = false
	enemy = enemy.get_parent()
	_create_bullet()	
	await(get_tree().create_timer(GameData.tower_data[type]["rate_of_fire"]).timeout)
	readytofire = true
#endregion

	
