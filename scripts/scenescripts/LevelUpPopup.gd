extends Control

var rng = RandomNumberGenerator.new()
#this temporarily holds which group to select a modifier from
var currentModifierGroups:Array = []
#dictionary is sorted like: [modifierGroup,modifierChoice,modifierValue,formattedModifierValue]
#modifierGroup is the turret group that the modifier is applied to (offensive,defensive,utility)
#modifierChoice is the stat that will be changed (damage, range, ect)
#modifierValue is the increment the stat will be changed (positive or negative)
#formattedModifierValue is the modifierValue with removed _ and making % increase/decrease display correctly
var modifier_choices = {
	1:[],
	2:[],
	3:[]
}

#label variables
@onready var firstChoiceLabel = $FirstChoice/Name
@onready var secondChoiceLabel = $SecondChoice/Name
@onready var thirdChoiceLabel = $ThirdChoice/Name

func _ready():
	_get_modifier_groups()
	_set_modifier_choices()
	_format_modifier_choices()
	_update_firstChoice_display()
	_update_secondChoice_display()
	_update_thirdChoice_display()

#region Modifier Methods
#current groups are: offensive, defensive, utility
func _get_modifier_groups():
	randomize()
	var counter = 0
	currentModifierGroups.clear()
	#pick 3 random groups that the modifiers will be pulled from
	while counter < 3:
		var numberOfModifiers = GameData.modifiers_data.size()-1
		var modifierChoice = rng.randi_range(0,numberOfModifiers)
		currentModifierGroups.append(modifierChoice)
		counter += 1

#this will update the modifier_choices dictionary to contain information about the 3 modifiers
func _set_modifier_choices():
	var counter = 1
	for group in currentModifierGroups:
		randomize()
		var modifierGroup = GameData.modifiers_data.keys()[currentModifierGroups[group]]

		var modifierGroupData = GameData.modifiers_data.get(modifierGroup)
		#print("size:" + str(modifierGroupData.size()))
		var randomModifier = rng.randi_range(0,modifierGroupData.size()-1)
		var modifierChoice = modifierGroupData.keys()[randomModifier]
		var modifierValue = modifierGroupData.get(modifierChoice)
		#print("modifierGroup: " + str(modifierGroup))
		#print("modifierChoice:" + str(modifierChoice))
		#print("modifierValue: " + str(modifierValue))
		modifier_choices[counter] = [modifierGroup,modifierChoice,modifierValue]
		counter += 1
#endregion

func _format_modifier_choices():
	for choice in modifier_choices:
		print("looped choice: " + str(modifier_choices[choice][1]))
		#replaces the _ in modifierChoice with spaces
		if modifier_choices[choice][1].contains("_"):
			modifier_choices[choice].append(modifier_choices[choice][1].replace("_", " "))
		else:
			modifier_choices[choice].append(modifier_choices[choice][1])
			
		#TODO: Make this work for negative modifiers
		#format the decimal increase/decrease as percentages
		if modifier_choices[choice][2] is float:
			var formatAsPercentage = str((1 - modifier_choices[choice][2]) * 100) + str("%")
			modifier_choices[choice][2] = formatAsPercentage
			print("formatted percentage value: " + str(formatAsPercentage) + str("%"))
	pass

#region Label Methods
func _update_firstChoice_display():	
	firstChoiceLabel.set_text("Increase " + str(modifier_choices[1][3]) + " by " + str(modifier_choices[1][2]) + " for " + str(modifier_choices[1][0]) + " turrets")
	
func _update_secondChoice_display():
	secondChoiceLabel.set_text("Increase " + str(modifier_choices[2][3]) + " by " + str(modifier_choices[2][2]) + " for " + str(modifier_choices[2][0]) + " turrets")
	
func _update_thirdChoice_display():
	thirdChoiceLabel.set_text("Increase " + str(modifier_choices[3][3]) + " by " + str(modifier_choices[3][2]) + " for " + str(modifier_choices[3][0]) + " turrets")
#endregion

 #region Button Methods
func _on_first_select_button_pressed():
	var group = modifier_choices[1][0]
	var modifier = modifier_choices[1][1]
	
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

func _on_second_select_button_pressed():
	var group = modifier_choices[2][0]
	var modifier = modifier_choices[2][1]
	
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

func _on_third_select_button_pressed():
	var group = modifier_choices[3][0]
	var modifier = modifier_choices[3][1]
	
	for tower in GameData.tower_data:	
		print(tower)
		print(GameData.tower_data[tower]["group"])
		if GameData.tower_data[tower]["group"] == group:
			if modifier == "rate_of_fire":
				GameData.tower_data[tower][modifier] *= GameData.modifiers_data[str(group)][str(modifier)]	
			else:
				GameData.tower_data[tower][modifier] += GameData.modifiers_data[str(group)][str(modifier)]
			#print("This tower has the correct group for the modifier")
		else:
			print("This tower does not have the correct group for the modifier")
			
	get_tree().paused = false
	queue_free()
#endregion
