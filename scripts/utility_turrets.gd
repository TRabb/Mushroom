extends Node2D
var built = false
var type
@onready var _turrets_node = get_node("/root/World/Turrets")
@onready var _UI_node = get_node("/root/World/UI")

#holds all turretnames that are within the range of utility turrets
var turret_array:Array = []
var turretType_array:Array = []



# Called when the node enters the scene tree for the first time.
func _ready():
	if built:
		self.get_node("Marker2D/Range/CollisionShape2D").get_shape().radius = .5 * GameData.tower_data[type]["range"]


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):

		#different functionality depending on turret type
		#defensive or offensive
	#_get_turret_types()
	#print(turret_array)
	pass


func _on_range_area_entered(area):
	#prevented the tooltip area2d triggering this by putting it to layer2 on the turret scene
	var turretName
	#need this check as before the tower was placed it was adding the buffs
	if _UI_node.get_node_or_null("TowerPreview") == null:
	#get all other turrets that are within range
		if area.find_parent("Turret*") != null:
			turretName = area.find_parent("Turret*").get_name()
			if not turret_array.has(turretName):
				turret_array.append(turretName)
				_turrets_node.turrets_dict[turretName]["damage"] += 1000
			
func _on_range_area_exited(area):
	var turretName
	if area.find_parent("Turret*") != null:
		turretName = area.find_parent("Turret*").get_name()
		if turret_array.has(turretName):
			turret_array.erase(turretName)
	
	

func _get_turret_types():
	turretType_array.clear()
	#get all turret types based on turret name in turret_array
	#use marker2d of turret to get the turret type
	for turret in turret_array:
		var a = self.get_node("Marker2D").get_child(0).name
		if not turretType_array.has(a):
			turretType_array.append(a)
	#print(turretType_array)
	#turretName = self.get_node("Marker2D").get_child(0).name		


	
	
	



	
