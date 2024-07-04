extends Node2D

var type
var enemy_array:Array = []
var built = false
var enemy
var readytofire  = true
var bullet
var animation_frame
var hoveredTurretPosition
var hoveredTurretName
var test = false
var hovering = false
#var toolTip = get_parent().get_parent().get_node("ToolTip")
var timeout = false
var turret_array:Array = []
var turret_name

@onready var toolTip = get_parent().get_node_or_null("ToolTip")
#@onready var timer = get_parent().get_node("Timer")
@onready var uiNode = get_node("/root/World/UI")
var range_texture
@onready var animated_sprite = get_node("Marker2D/Turret1")

func _ready():
	if built:
		self.get_node("Marker2D/Range/CollisionShape2D").get_shape().radius = .5 * GameData.tower_data[type]["range"]

func _physics_process(_delta):
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
					enemy_hit.on_hit(self.get_parent().turrets_dict[turret_name]["damage"])
			else:
				print("Enemy is dead")
		if readytofire:
			#This is working for animations. Commenting out as I do not have all turrets animated
			_turret_animation()
			_fire()
	else:
		enemy = null	

func _process(_delta):
	if Input.is_action_pressed("mb_left"):
		#check if the turret is being hovered. this prevents tooltips from showing when user is deciding to place a turret
		if hovering:
			_display_toolTip(hoveredTurretName)
#region Turret Range Methods
func _on_range_body_entered_utility(body):
	var turretName
	if body.is_in_group("Turret"):
			#need this check as before the tower was placed it was adding the buffs
			if uiNode.get_node_or_null("TowerPreview") == null:
				print("turret in area")
			#get all other turrets that are within range
				if body.get_parent() != null:
					turretName = body.get_parent().get_name()
					if not turret_array.has(turretName):
						turret_array.append(turretName)
						if not body.is_in_group("Utility"):
							self.get_parent().turrets_dict[turretName]["damage"] += 1000
						
func _on_range_body_entered(body):
	if body.is_in_group("Enemy"):
		#check required so nodes in the Bullet group are not added to the enemy array
			enemy_array.append(body.get_parent())

func _on_range_body_exited_utility(body):
	var turretName
	if body.is_in_group("Turret"):
		if body.find_parent("Turret*") != null:
			turretName = body.find_parent("Turret*").get_name()
			if turret_array.has(turretName):
				turret_array.erase(turretName)
	
func _on_range_body_exited(body):
	#check required so nodes that are enemies are not removed from the enemy array when they leave a turrets range
	if not body.is_in_group("Bullet"):
		enemy_array.erase(body.get_parent())
	else:
		#check to make sure the range the bullet left is from the turret it was shot from
		if self.get_node("Marker2D/Range").has_node("BulletCharacterBody2D"):
		#if the bullet leaves the turret range remove it
			body.queue_free()
			
#endregion

#region Turret Shooting Methods
func _select_enemy():
	#print("select enemy turret name: " + turret_name)
	if GameData.tower_data[type]["rate_of_fire"] > 0:
		#select the enemy that has the furthest progress down the curve2d
		var enemy_progress_array = []
		for i in enemy_array:
			if i.get_progress() != null:
				enemy_progress_array.append(i.get_progress())
		var max_progress = enemy_progress_array.max()
		var enemy_index = enemy_progress_array.find(max_progress)
		enemy = enemy_array[enemy_index]
	
func _create_bullet():
	if GameData.tower_data[type]["rate_of_fire"] > 0:
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
	if GameData.tower_data[type]["rate_of_fire"] > 0:
		readytofire = false
		enemy = enemy.get_parent()
		_create_bullet()	
		await(get_tree().create_timer(self.get_parent().turrets_dict[turret_name]["rate_of_fire"]).timeout)
		readytofire = true	
	
#endregion

#region Utility Methods
func _turret_animation():
	#FIXME: Need to add an animation to turret2 or it will crash everytime it tries to fire
	#animated_sprite.play("shoot")
	await get_tree().create_timer(1).timeout
	#animated_sprite.stop()
	
func _turret_tracking():
	if GameData.tower_data[type]["rate_of_fire"] > 0:
		var marker2D = get_node("Marker2D")
		marker2D.look_at(enemy.get_global_position())
#endregion

#region ToolTip Methods
func _on_area_2d_mouse_entered():
	#prevents area2d getting triggered when user is trying to place a turret
	if uiNode.is_tower_preview() == false:
		hovering = true
		hoveredTurretPosition = self.position
		hoveredTurretName = self.name
		#print("hoveredTurretName " + hoveredTurretName)

func _on_area_2d_mouse_exited():
	hovering = false
	toolTip.hide()
	if range_texture != null:
		range_texture.hide()

func _display_toolTip(turretName): 
	turretName = self.get_node("Marker2D").get_child(0).name
	#give this function the name of the turret that is being hovered
	toolTip.set_hovered_turret(hoveredTurretName)
	#updates label with correct information and makes the tooltip visible
	toolTip.update_turret_toolTip()
	#creates and displays an outline of turret range
	_create_range_display(turretName)
	
func _create_range_display(turretName):
	#poplates the ToolTipRangeDisplay sprite with the turrets range
	range_texture = toolTip.get_parent().get_node("ToolTipRangeDisplay")
	var scaling = GameData.tower_data[turretName]["range"] / 600.0
	range_texture.scale = Vector2(scaling,scaling)
	range_texture.modulate = Color("ad54ff3c")
	range_texture.position = hoveredTurretPosition
	var texture = load("res://assets/defenses/range_overlay.png")
	range_texture.texture = texture
	range_texture.show()
#endregion
