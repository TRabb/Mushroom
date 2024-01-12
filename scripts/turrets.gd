extends Node2D

var type
var enemy_array:Array = []
var built = false
var enemy
var readytofire= true
var bullet
var animation_frame

@onready var animated_sprite = get_node("Marker2D/Turret1")

func _ready():
	if built:
		self.get_node("Marker2D/Range/CollisionShape2D").get_shape().radius = .5 * GameData.tower_data[type]["range"]

func _physics_process(delta):
	if enemy_array.size() != 0 and built:
		_select_enemy()
		_turret_tracking()
		#check to see if the bullet collision box and enemy collision box hit. if so, deal damage
		if bullet != null and bullet.enemy_hit():
			var enemy_hit_id = bullet.get_enemy_id()
			#gets the instance of the path2d from the id of the character2d collisionbox
			if instance_from_id(enemy_hit_id) != null:
				bullet.queue_free()
				var enemy_hit = instance_from_id(enemy_hit_id).get_parent().get_parent()
			#path2d is required to use the functions within the enemy scripts
				if enemy_hit is Path2D:
					enemy_hit.on_hit(GameData.tower_data[type]["damage"])
			else:
				print("Enemy is dead")
		if readytofire:
			_turret_animation()
			_fire()
	else:
		enemy = null	

#region Turret Range Methods
func _on_range_body_entered(body):
	#check required so nodes in the Bullet group are not added to the enemy array
	if not body.is_in_group("Bullet"):
		enemy_array.append(body.get_parent())

func _on_range_body_exited(body):
	#check required so nodes that are enemies are not removed from the enemy array when they leave a turrets range
	if not body.is_in_group("Bullet"):
		enemy_array.erase(body.get_parent())
	else:
		#check to make sure the range the bullet left is from the turret it was shot from
		if self.get_node("Marker2D/Range").has_node("CharacterBody2D"):
		#if the bullet leaves the turret range remove it
			body.queue_free()
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
	bullet = load("res://scenes/defenses/bullet.tscn").instantiate()
	get_node("Marker2D/Range").add_child(bullet)
	bullet.position = Vector2(22,0)
	var turretGlobalPosition = Vector2(self.position.x, self.position.y)
	var enemyPosition = enemy.current_position()
	var turretParent = self.get_node("Marker2D")
	bullet.set_parent_turret(turretParent.get_child(0).get_name())
		
	#this gets the location of the enemy relative to the turret
	var bulletDestination = enemyPosition - turretGlobalPosition
	
	bullet.set_velocity(bulletDestination - bullet.position)
	
func _fire():
	readytofire = false
	enemy = enemy.get_parent()
	_create_bullet()	
	await(get_tree().create_timer(GameData.tower_data[type]["rate_of_fire"]).timeout)
	readytofire = true	
	
#endregion

#region Utility Methods
func _turret_animation():
	#FIXME: Need to add an animation to turret2 or it will crash everytime it tries to fire
	animated_sprite.play("shoot")
	await get_tree().create_timer(1).timeout
	animated_sprite.stop()
	
func _turret_tracking():
	var marker2D = get_node("Marker2D")
	marker2D.look_at(enemy.get_global_position())
		
#endregion
