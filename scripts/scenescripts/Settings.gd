extends Control

#TODO: Settings menu should pause game when open
#TODO: Add functionality to resume and main menu button
#TODO: Save and exit

func _ready():
	pass


func _process(delta):
	pass


func _resume_button_pressed():
	self.queue_free()
	pass


func _main_menu_button_pressed():
	self.queue_free()
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/menus/MainMenu.tscn")	
	pass
