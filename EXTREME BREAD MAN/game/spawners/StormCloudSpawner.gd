extends Node2D

var spawn_rate = 17
var max_d_from_player = 300
var min_d_from_player = 200

onready var stormcloud = preload("res://game/enemies/StormCloud.tscn")
onready var level_root = get_tree().get_nodes_in_group("level_root")[0]
onready var spawn_timer = $SpawnTimer

var rng = RandomNumberGenerator.new()

var player : Node2D
var difficulty_mult # Multiplied with spawn rate

func _ready():
	rng.randomize()
	yield(get_tree(),"idle_frame")
	#Player wont be parent of this so have to get reference late
	player = get_tree().get_nodes_in_group("player")[0]
	spawn_timer.wait_time = spawn_rate
	spawn_timer.start()

func _process(delta):
	difficulty_mult = level_root.get_difficulty()

func spawn_stormcloud(pos:Vector2):
	var i_stormcloud = stormcloud.instance()
	call_deferred("add_child",i_stormcloud)
	i_stormcloud.global_position = pos


func _on_SpawnTimer_timeout():
	var coin = rng.randi_range(0,1)
	var rand_pos_x = 0
	if coin == 0:
		rand_pos_x = (player.global_position.x + min_d_from_player) + rng.randi_range(0,max_d_from_player-min_d_from_player)
	else:
		rand_pos_x = (player.global_position.x - min_d_from_player) - rng.randi_range(0,max_d_from_player-min_d_from_player)
	spawn_stormcloud(Vector2(rand_pos_x,0))
	spawn_timer.wait_time = spawn_rate / difficulty_mult
	spawn_timer.start()

