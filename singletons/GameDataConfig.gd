extends Node

func reset():
	#this is used when generating new maps/starting new games to reset the player values back to default
	player_data.player.health = 5
	player_data.player.current_wave = 0
	player_data.player.money = 100
	player_data.player.current_level = 1
	player_data.player.xp = 0
	player_data.player.xp_to_level = 10
	#default values for turret1
	tower_data["Turret1"]["damage"] = 20
	tower_data["Turret1"]["rate_of_fire"] = 1.0
	tower_data["Turret1"]["range"] = 300
	tower_data["Turret1"]["bullet_speed"] = 850
	tower_data["Turret1"]["cost"] = 5
	#default values for turret2
	tower_data["Turret2"]["damage"] = 30
	tower_data["Turret2"]["rate_of_fire"] = 1.0
	tower_data["Turret2"]["range"] = 750
	tower_data["Turret2"]["bullet_speed"] = 850
	tower_data["Turret2"]["cost"] = 10
	

var tower_data = {
	"Turret1": {
		"damage": 20,
		"rate_of_fire": 1.0,
		"range": 300,
		"bullet_speed": 850,
		"cost":5,
		"group":"offensive"},
	"Turret2":{
		"damage": 30,
		"rate_of_fire": 1.0,
		"range": 750,
		"bullet_speed": 850,
		"cost": 10,
		"group":"defensive"}
	}

var enemy_data = {
	"farmer_enemy":{
		"speed": 250,
		"hp": 30,
		"reward": 1,
		"xp": 8,
		"damage": 1,
		"spawn_wave": 1},
	"yellow_enemy":{
		"speed": 400,
		"hp": 75,
		"reward": 2,
		"xp": 3,
		"damage": 5,
		"spawn_wave": 5}
}

var player_data = {
	"player":{
		"health": 5,
		"money": 100,
		"xp": 0,
		"xp_to_level": 10,
		"current_level": 1,
		"current_wave": 0}
}

#modifiers will only be applied to the appropriate turret group
#want to weight these eventually 
#1.1 is 10% increase
#.9 is 10% decrease
#this is backwards for rate of fire. increasing rate of fire makes the number go down as it is the delay between shots
var modifiers_data = {
	"offensive":{
		"damage":40,
		"rate_of_fire":.9,
		"range":300,
		"bullet_speed":600
	},"defensive":{
		"cost":20
	}
	#,	"utility":{	
		#"damage":40
	#}
}
