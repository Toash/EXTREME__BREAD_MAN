extends Node2D


# Get random point in curve

# Spawn seagull on it
var seagull : PackedScene= preload("res://game/seagull/Seagull.tscn")

var rng = RandomNumberGenerator.new()
onready var path : Path2D =  $Path2D
onready var path_point = $Path2D/PathFollow2D
onready var path_length = path.curve.get_baked_length()

func set_random_path_point():
	var random_offset = rng.randi_range(0,path_length)
	path_point.offset = random_offset


func spawn_seagull():
	var seagull_instance = seagull.instance()
	seagull_instance.global_position = path_point
	
	
	

