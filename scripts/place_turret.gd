extends TileMap

var clickedTile:Vector2
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _physics_process(delta):
	#left click any tile will change it to grass tile - use something like this for turret placement
	#user clicks button to get turret sprite to show on cursor - want this to be drag eventually
	#next tile that is left clicked will have a turret placed there
	#clickedTile = local_to_map(get_global_mouse_position())
	#if(Input.is_action_just_pressed("mb_left") and not get_cell_source_id(0, clickedTile,false) == 0):
		#set_cell(0, clickedTile, 2, Vector2i(0,0), 0)
	pass
