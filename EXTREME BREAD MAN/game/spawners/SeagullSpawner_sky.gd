extends Node2D

var max_spawn_rate = 1
var cur_spawn_rate = 2.5

var seagull : PackedScene= preload("res://game/seagull/Seagull.tscn")

var rng = RandomNumberGenerator.new()
onready var path : Path2D =  $Path2D
onready var path_point = $Path2D/PathFollow2D
onready var path_length = path.curve.get_baked_length()
onready var spawn_timer = $SpawnTimer
onready var player :Node2D
onready var level_root = get_tree().get_nodes_in_group("level_root")[0]


func _ready():
	spawn_timer.start()
	yield(get_tree(),"idle_frame")
	var players = get_tree().get_nodes_in_group('player')
	if players.size()>0:
		player = get_tree().get_nodes_in_group('player')[0]
	
func _process(delta):
	match(level_root.get_difficulty_number()):
		1:
			spawn_timer.wait_time = 4
		2:
			spawn_timer.wait_time = 3
		3:
			spawn_timer.wait_time = 2
		4:
			spawn_timer.wait_time = 1.5
		5:
			spawn_timer.wait_time = 1.2
		_: 
			printerr("Invalid difficulty!!")

func set_random_path_point():
	var random_offset = rng.randi_range(0,path_length)
	path_point.offset = random_offset

func spawn_seagull(target_node):
	set_random_path_point()
	var seagull_instance = seagull.instance()
	seagull_instance.global_position = path_point.global_position
	get_tree().root.add_child(seagull_instance)
	seagull_instance.set_target(target_node,true)
	
func _on_SpawnTimer_timeout():
	if is_instance_valid(player):
		spawn_seagull(player)
	spawn_timer.wait_time = cur_spawn_rate
	spawn_timer.start()
