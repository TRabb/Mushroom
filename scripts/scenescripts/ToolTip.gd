extends TextureRect

@onready var textLabel = $Text

var hoveredTurret
# Called when the node enters the scene tree for the first time.
func _ready():
	self.hide()
	pass



func update_turret_stats_display():
	#get the hovered turret from World
	#foreach through all of the key:value pairs for the correct turret
	#var hoveredTurretStats = GameData.tower_data.get(hoveredTurret)
	#Stat is key
	#hoveredTurretStats is value
	self.show()
	textLabel.set_text("Type: " + str(GameData.tower_data[hoveredTurret]["group"]) + "
						Damage: " + str(GameData.tower_data[hoveredTurret]["damage"]) + "
						Attack Speed (per second): " + str(GameData.tower_data[hoveredTurret]["rate_of_fire"]) + "
						Range: " + str(GameData.tower_data[hoveredTurret]["range"]) + "
						Bullet Speed: " + str(GameData.tower_data[hoveredTurret]["bullet_speed"]) + "
						Cost: " + str(GameData.tower_data[hoveredTurret]["cost"]))
	pass

func kill():
	self.queue_free()
	
func set_hovered_turret(turret):
	hoveredTurret = turret
	#print(hoveredTurret)
