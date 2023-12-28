extends Label

var level = 1 : set = set_level, get = get_level

func set_level(value):
	level = value
	text = "Player Level: " + str(value)

func get_level():
	return level
