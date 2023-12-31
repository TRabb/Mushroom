extends Label

var wave = 1 : set = set_wave, get = get_wave

func set_wave(value):
	wave = value
	text = "Wave: " + str(value)

func get_wave():
	return wave
