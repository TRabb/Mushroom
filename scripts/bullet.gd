extends CharacterBody2D

var speed = 600
var enemyLocation
var hit

func _physics_process(delta):
	#TODO: Pass collider id so I can check to see which enemy object I actually hit
	#situation happens when shooting at enemy but hit a different deals damange to targeted enemy not hit enemy
	hit = false
	var collision_info = move_and_collide(get_velocity().normalized() * delta * speed)
	if collision_info:
		print("Collider ID: " + str(collision_info.get_collider_id()))
		hit = true

func get_enemy_location(location:Vector2):
	enemyLocation = location
	
func enemy_hit():
	return hit
