extends Control

var currentModifierGroups:Array = []
var rng = RandomNumberGenerator.new()

var firstChoice
var secondChoice
var thirdChoice

@onready var firstChoiceLabel = $FirstChoice/Name

func _ready():
	_get_modifier_groups()
	_update_firstChoice_display()

func _on_button_pressed():
	print("PRESSED")
	get_tree().paused = false
	queue_free()


#on button press, apply modifier to the appropriate turret group
#might need a method to update turret stats ? not sure

#pick 3 random groups that the modifiers will be pulled from
func _get_modifier_groups():
	randomize()
	var counter = 0
	currentModifierGroups.clear()
	while counter < 3:
		var numberOfModifiers = GameData.modifiers_data.size()-1
		var modifierChoice = rng.randi_range(0,numberOfModifiers)
		currentModifierGroups.append(modifierChoice)
		counter += 1
	pass
	

#REFACTOR: Create one method that assigns all of the #Choice variables
#use those variables to populate the lables
#this code works just refactor

#get the first modifier from the array of selected groups
func _update_firstChoice_display():
	randomize()
	var modifierGroup = GameData.modifiers_data.keys()[currentModifierGroups[0]]
	
	var modifierGroupData = GameData.modifiers_data.get(modifierGroup)
	#print("size:" + str(modifierGroupData.size()))
	var randomModifier = rng.randi_range(0,modifierGroupData.size()-1)
	var modifierChoice = modifierGroupData.keys()[randomModifier]
	var modifierValue = modifierGroupData.get(modifierChoice)
	print("modifierGroup: " + str(modifierGroup))
	print("modifierChoice:" + str(modifierChoice))
	print("modifierValue: " + str(modifierValue))
	
	firstChoiceLabel.set_text("Increase " + str(modifierChoice) + " by " + str(modifierValue))
	print(firstChoiceLabel.get_text())
	#format this data to update the name label appropriately
	firstChoice = [modifierGroup,modifierChoice]
	#GameData.modifiers_data[str(modifierGroup)][str(modifierChoice)]
	pass

#TODO: duplicate this for the other buttons 
func _on_first_select_button_pressed():
	print(firstChoice)
	#firstChoice = [modifierGroup,modifierChoice]
	var group = firstChoice[0]
	var modifier = firstChoice[1]
	
	for tower in GameData.tower_data:	
		print(tower)
		print(GameData.tower_data[tower]["group"])
		if GameData.tower_data[tower]["group"] == group:
			if modifier == "rate_of_fire":
				GameData.tower_data[tower][modifier] *= GameData.modifiers_data[str(group)][str(modifier)]	
			else:
				GameData.tower_data[tower][modifier] += GameData.modifiers_data[str(group)][str(modifier)]
			print("This tower has the correct group for the modifier")
		else:
			print("This tower does not have the correct group for the modifier")
			
	get_tree().paused = false
	queue_free()

	pass # Replace with function body.
