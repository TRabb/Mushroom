extends CanvasLayer

func set_tower_preview(tower_type, mouse_position):
	var drag_tower = load("res://scenes/Turret.tscn").instantiate()
	drag_tower.set_name("DragTower")
	#Color requires rgba value... ad54ff3c converted from this hex
	drag_tower.modulate = Color.hex(0xad54ff3c)
	
	#this control is removed after a turret is placed or building is canceled
	var control = Control.new()
	control.add_child(drag_tower,true)
	control.position = mouse_position
	control.set_name("TowerPreview")
	add_child(control,true)
	move_child(get_node("TowerPreview"), 0)

func update_tower_preview(new_position, color):
	get_node("TowerPreview").position = new_position
	var modulate = get_node("TowerPreview").get_modulate() 
	if get_node("TowerPreview/DragTower").modulate != Color(color):
		get_node("TowerPreview/DragTower").modulate = Color(color)
