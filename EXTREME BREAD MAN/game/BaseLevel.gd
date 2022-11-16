extends Node

export (Color) var background_color

var difficulty_factor = 0
var d_rate = .1

onready var stormcloud = preload("res://game/enemies/StormCloud.tscn")

var max_difficulty = 10

func _ready():
	print('test')
	VisualServer.set_default_clear_color(background_color)
	spawn_stormcloud(Vector2.ZERO)
	
func _process(delta):
	difficulty_factor = clamp(difficulty_factor + d_rate*delta,0,max_difficulty)
	#print(difficulty_factor)

func spawn_stormcloud(pos:Vector2):
	var i_stormcloud = stormcloud.instance()
	call_deferred("add_child",i_stormcloud)
	i_stormcloud.global_position = pos
	
