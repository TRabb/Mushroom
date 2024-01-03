extends Control

func _on_button_pressed():
	print("PRESSED")
	get_tree().paused = false
	queue_free()
