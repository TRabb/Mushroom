extends "res://scripts/turrets.gd"

var toolTipScene
var turretName
var timer = Timer.new()

func _ready():
	#add the timer that determines if tooltip should show or not
	#requires user to hoveer tower for X seconds before showing
	self.add_child(timer)
	timer.set_one_shot(true)
	timer.connect("timeout", _instantiate_toolTip)
	pass

func on_area_2d_mouse_entered():
	print("ENETERED")
	#print(timer)

	#surely there is a better way to do this..
	var uiNode = get_parent().get_parent().get_node("UI")
	#instantiate a tooltip
	if uiNode != null:
		#check if the turret is in preview mode. this prevents tooltips from showing when user is deciding to place a turret
		if uiNode.is_tower_preview() == false:
			timer.set_paused(false)
			timer.start(1.5)

	pass # Replace with function body.

func _instantiate_toolTip():
	toolTipScene = load("res://scenes/menus/ToolTip.tscn").instantiate()
	self.add_child(toolTipScene)
	turretName = self.get_node("Marker2D").get_child(0).name
	#give this function the name of the turret that is being hovered
	toolTipScene.set_hovered_turret(turretName)
	toolTipScene.update_turret_stats_display()

func on_area_2d_mouse_exited():
	print("EXITED")
	timer.set_paused(true)
	print("timerexited:" + str(timer.get_time_left()))
	if timer.get_time_left() > 0:
		timer.set_wait_time(1.5)
		print("timer:" + str(timer.get_time_left()))
	if get_node("ToolTip") != null:
		toolTipScene.queue_free()
	pass # Replace with function body.
