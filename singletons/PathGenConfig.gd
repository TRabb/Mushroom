extends Resource
class_name PathGenConfig

#size of map - can measure 2d to get size in units
#length is +1 to the actual size of map to make path look like it goes off the map
#IF YOU CHANGE THESE VARIABLES ALSO SAVE THE RESOURCE MANUALLY
#IT LOOKS LIKE IT SAVES BUT IT REALLY DOESNT
@export var map_length:int = 24
@export var map_height:int = 11
