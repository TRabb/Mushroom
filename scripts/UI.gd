extends CanvasLayer

var tower_range = 250

func set_tower_preview(tower_type, mouse_position):
	
	#get the preview of the sprite based on the tower type selected
	var drag_tower = load("res://scenes/" + tower_type + ".tscn").instantiate()
	drag_tower.set_name("DragTower")
	
	var range_texture = Sprite2D.new()
	#range_texture.position = Vector2(32,32)
	var scaling = GameData.tower_data[tower_type]["range"] / 600.0
	range_texture.scale = Vector2(scaling,scaling)
	var texture = load("res://assets/range_overlay.png")
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
