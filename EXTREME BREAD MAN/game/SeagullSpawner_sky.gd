extends Node2D

var spawn_rate = 2

var seagull : PackedScene= preload("res://game/seagull/Seagull.tscn")

var rng = RandomNumberGenerator.new()
onready var path : Path2D =  $Path2D
onready var path_point = $Path2D/PathFollow2D
onready var path_length = path.curve.get_baked_length()
onready var spawn_timer = $SpawnTimer
onready var player :Node2D= get_tree().get_nodes_in_group('player')[0]

func _ready():
	spawn_timer.wait_time = spawn_rate 

func set_random_path_point():
	var random_offset = rng.randi_range(0,path_length)
	path_point.offset = random_offset

func spawn_seagull(target_node):
	set_random_path_point()
	var seagull_instance = seagull.instance()
	seagull_instance.global_position = path_point.global_position
	get_tree().root.add_child(seagull_instance)
	seagull_instance.set_target(target_node)
	
func _on_SpawnTimer_timeout():
	spawn_seagull(player)
