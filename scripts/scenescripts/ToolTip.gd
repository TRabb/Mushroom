extends TextureRect

@onready var textLabel = $Text

var hoveredTurret
# Called when the node enters the scene tree for the first time.
func _ready():
	self.hide()
	pass

func _process(_delta):
	self.position = get_global_mouse_position() + Vector2(16,-16)
	pass	

func update_turret_toolTip():
	#range is not included here at it has a visual display
	#var hoveredTurretStats = GameData.tower_data.get(hoveredTurret)
	#Stat is key
	#hoveredTurretStats is value
	self.show()
	textLabel.set_text("Type: " + str(GameData.tower_data[hoveredTurret]["group"]) + "
						Damage: " + str(GameData.tower_data[hoveredTurret]["damage"]) + "
						Attack Speed (per second): " + str(GameData.tower_data[hoveredTurret]["rate_of_fire"]) + "
						Bullet Speed: " + str(GameData.tower_data[hoveredTurret]["bullet_speed"]) + "
						Cost: " + str(GameData.tower_data[hoveredTurret]["cost"]))
	pass

func kill():
	self.queue_free()
	
func set_hovered_turret(turret):
	hoveredTurret = turret
	#print(hoveredTurret)


