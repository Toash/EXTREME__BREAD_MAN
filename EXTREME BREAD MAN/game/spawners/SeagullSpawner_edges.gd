extends Node2D

var max_spawn_vert_offset = 100
var max_spawn_rate = 1
var cur_spawn_rate = 2.5

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
	difficulty = level_root.get_difficulty()

func spawn_seagull(spawn_point:Vector2, target_point:Vector2):
	var seagull_i = seagull.instance()
	get_tree().root.add_child(seagull_i)
	seagull_i.global_position = spawn_point
	seagull_i.set_target(target_point,false)

func _on_SpawnTimer_timeout():
	var random = rng.randi_range(0,max_spawn_vert_offset)
	var pos = left.global_position + Vector2.UP*random
	spawn_seagull(pos,right.global_position+Vector2.UP*random)
	spawn_timer.wait_time = cur_spawn_rate
	spawn_timer.start()
