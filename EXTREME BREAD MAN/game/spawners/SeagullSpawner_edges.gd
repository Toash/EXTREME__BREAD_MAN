extends Node2D

var max_vert_offset = 100
var max_spawn_rate = 1
var cur_spawn_rate = 3

var seagull : PackedScene= preload("res://game/seagull/Seagull.tscn")

var rng = RandomNumberGenerator.new()
onready var spawn_timer = $SpawnTimer
onready var player :Node2D= get_tree().get_nodes_in_group('player')[0]
onready var level_root = get_tree().get_nodes_in_group("level_root")[0]

onready var left = $LeftEdge
onready var right = $RightEdge

var difficulty

func _ready():
	spawn_timer.wait_time = cur_spawn_rate
	spawn_timer.start()
	
func _process(delta):
	difficulty = level_root.get_difficulty_number()

func spawn_seagull(spawn_point:Vector2, target_point:Vector2):
	"""
	Seagull can either spawn on the left or right
	"""
	var seagull_i = seagull.instance()
	get_tree().root.add_child(seagull_i)
	seagull_i.global_position = spawn_point
	seagull_i.set_target(target_point,false)

func get_random_edge_point(is_left:bool)->Vector2:
	"""
	Gets random point either on left or right side depending on bool
	"""
	var random = rng.randi_range(0,max_vert_offset)
	var pos : Vector2
	if is_left:
		pos = left.global_position + Vector2.UP*random
	else:
		pos = right.global_position + Vector2.UP*random
	return pos
	

func _on_SpawnTimer_timeout():
	var coin : bool = bool(rng.randi_range(0,1)) #Heads or tails
	var spawn_pos = get_random_edge_point(coin)
	var target_pos = get_random_edge_point(!coin)
	spawn_seagull(spawn_pos,target_pos)
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
			printerr("Invalid difficuly!!")
	
	spawn_timer.start()
	print("Spawning")
