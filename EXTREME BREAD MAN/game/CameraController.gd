extends Camera2D

var target : Vector2
var player : Node2D

var followRate = 0.5

func _ready():
	player = get_tree().get_nodes_in_group('player')[0]

func _process(delta):
	acquire_target_pos()
	go_towards_target(delta)                                
	
func acquire_target_pos():
	target = player.global_position
	
func go_towards_target(delta):
	#global_position = lerp(global_position, target,followRate*delta)
	global_position = target
