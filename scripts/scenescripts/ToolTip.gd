extends TextureRect

@onready var textLabel = $Text
@onready var turrets_node = get_node("/root/World/Turrets")

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
	textLabel.set_text("Type: " + str(turrets_node.turrets_dict[hoveredTurret]["type"]) + "
						Damage: " + str(turrets_node.turrets_dict[hoveredTurret]["damage"]) + "
						Attack Speed (per second): " + str(turrets_node.turrets_dict[hoveredTurret]["rate_of_fire"]) + "
						Bullet Speed: " + str(turrets_node.turrets_dict[hoveredTurret]["bullet_speed"]) + "
						Cost: " + str(turrets_node.turrets_dict[hoveredTurret]["cost"]))
	pass

func kill():
	self.queue_free()
	
func set_hovered_turret(turret):
	hoveredTurret = turret
	#print(hoveredTurret)


