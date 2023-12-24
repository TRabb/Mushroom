extends Label

var health = GameData.player_data["player"]["health"] : set = set_health, get = get_health

func set_health(value):
	health = value
	text = "Health: " + str(value)

func get_health():
	return health
