extends Node

var tower_data = {
	"Turret1": {
		"damage": 20,
		"rate_of_fire": 1,
		"range": 300,
		"cost":10},
	"Turret2":{
		"damage": 20,
		"rate_of_fire": 1,
		"range": 750,
		"cost": 20}
	}

var enemy_data = {
	"godot_enemy":{
		"speed": 150,
		"hp": 50,
		"reward": 1},
	"yellow_enemy":{
		"speed": 150,
		"hp": 75,
		"reward": 2}
}

var player_data = {
	"player":{
		"money": 10,
		"current_wave": 0}
}
