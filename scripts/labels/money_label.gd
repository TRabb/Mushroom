extends Label

var money = 0 : set = set_money, get = get_money

func set_money(value):
	money = value
	text = "Money: " + str(value)

func get_money():
	return money
