extends CanvasLayer

#Label variables
@onready var moneyLabel = $HUD/PlayerInfo/Money
@onready var healthLabel = $HUD/PlayerInfo/Health
@onready var playerLevelLabel = $HUD/PlayerInfo/PlayerLevel
@onready var waveLabel = $HUD/PlayerInfo/CurrentWave
@onready var xpBar = $HUD/XPBar

#region Tower Preview Methods
func set_tower_preview(tower_type, mouse_position):
	
	#get the preview of the sprite based on the tower type selected
	var drag_tower = load("res://scenes/defenses/" + tower_type + ".tscn").instantiate()
	drag_tower.set_name("DragTower")
	
	var range_texture = Sprite2D.new()
	#range_texture.position = Vector2(32,32)
	var scaling = GameData.tower_data[tower_type]["range"] / 600.0
	range_texture.scale = Vector2(scaling,scaling)
	var texture = load("res://assets/defenses/range_overlay.png")
	range_texture.texture = texture
	range_texture.modulate = Color("ad54ff3c")
	#sets color for drag preview
	#drag_tower.modulate = Color.hex(0xad54ff3c)
	
	#this control is removed after a turret is placed or building is canceled
	var control = Control.new()
	control.add_child(drag_tower,true)
	control.add_child(range_texture,true)
	control.position = mouse_position
	control.set_name("TowerPreview")
	add_child(control,true)
	move_child(get_node("TowerPreview"), 0)
	
func update_tower_preview(new_position, color):
	#verifies that the modualte (aka opacity) is correct
	get_node("TowerPreview").position = new_position
	var modulate = get_node("TowerPreview").get_modulate() 
	if get_node("TowerPreview/DragTower").modulate != Color(color):
		get_node("TowerPreview/DragTower").modulate = Color(color)
		get_node("TowerPreview/Sprite2D").modulate = Color(color)
		
func is_tower_preview():
	#verify the tower is not a preview
	if get_node("TowerPreview") == null:
		return false
	else:
		return true
	pass
#endregion
		
#region Label Update Methods#
func update_money_display():
	moneyLabel.money = str(GameData.player_data["player"]["money"])
	
func update_health_display():
	healthLabel.health = str(GameData.player_data["player"]["health"])
	get_parent().is_player_dead()
	
func update_playerLevel_display():
	playerLevelLabel.level = str(GameData.player_data["player"]["current_level"])
	
func update_xp_bar():
	xpBar.max_value = GameData.player_data["player"]["xp_to_level"]
	xpBar.value = GameData.player_data["player"]["xp"]
	
func update_wave_display():
	waveLabel.wave = str(GameData.player_data["player"]["current_wave"])
#endregion
