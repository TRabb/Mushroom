extends Node

func reset():
	#this is used when generating new maps/starting new games to reset the player values back to default
	player_data.player.health = 100
	player_data.player.current_wave = 0
	player_data.player.money = 100
	player_data.player.current_level = 1
	player_data.player.xp = 0
	player_data.player.xp_to_level = 1000

var tower_data = {
	"Turret1": {
		"damage": 20,
		"rate_of_fire": 1.0,
		"range": 300,
		"bullet_speed": 850,
		"cost":5},
	"Turret2":{
		"damage": 30,
		"rate_of_fire": 1.0,
		"range": 750,
		"bullet_speed": 850,
		"cost": 10}
	}

var enemy_data = {
	"farmer_enemy":{
		"speed": 250,
		"hp": 50,
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
		"xp_to_level": 1000,
		"current_level": 1,
		"current_wave": 0}
}

