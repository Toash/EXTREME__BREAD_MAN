extends Node2D


onready var level_root = get_tree().get_nodes_in_group("level_root")[0]

var bread = preload("res://game/Bread.tscn")

var rng = RandomNumberGenerator.new()

func _ready():
	level_root.connect("seagulls_stronger",self,"on_seagulls_stronger")
	
func on_seagulls_stronger():
	var random_x = rng.randf_range(-400,500)
	drop_bread(random_x)
	pass
	
func drop_bread(x:float):
	var bread_instance = bread.instance()
	get_tree().root.add_child(bread_instance)
	bread_instance.global_position = Vector2(x,-300)
	
