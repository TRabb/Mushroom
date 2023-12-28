extends CharacterBody2D

var speed = 600
var enemyLocation
var enemy_hit_id
var hit
var parentTurret
var turretType

func _physics_process(delta):
	#situation happens when shooting at enemy but hit a different deals damange to targeted enemy not hit enemy
	hit = false
	var collision_info = move_and_collide(get_velocity().normalized() * delta * speed)
	if collision_info:
		hit = true
		enemy_hit_id = collision_info.get_collider_id()

func get_enemy_location(location:Vector2):
	enemyLocation = location
	
func enemy_hit():
	#returns true if the something was hit
	return hit
	
func get_enemy_id():
	#this is used to check which enemy needs to take damage
	return enemy_hit_id

func set_parent_turret(turret):
	turretType = turret
	
func get_parent_turret():
	return turretType
	
