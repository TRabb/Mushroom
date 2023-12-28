extends Node

func reset():
	#this is used when generating new maps/starting new games to reset the player values back to default
	player_data.player.health = 1
	player_data.player.current_wave = 1
	player_data.player.money = 100
	player_data.player.current_level = 1
	player_data.player.xp = 0
	player_data.player.xp_to_level = 10

var tower_data = {
	"Turret1": {
		"damage": 20,
		"rate_of_fire": 1.0,
		"range": 300,
		"cost":5},
	"Turret2":{
		"damage": 30,
		"rate_of_fire": 1.0,
		"range": 750,
		"cost": 10}
	}

var enemy_data = {
	"farmer_enemy":{
		"speed": 250,
		"hp": 50,
		"reward": 1,
		"xp": 8,
		"damage": 1},
	"yellow_enemy":{
		"speed": 500,
		"hp": 75,
		"reward": 2,
		"xp": 3,
		"damage": 5}
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

var wave_data = {
	
}
