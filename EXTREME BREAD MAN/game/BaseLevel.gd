"""
Contains difficulty, maintains higher order things
that aren't global
"""

extends Node

signal seagulls_stronger

onready var ground = $Ground

export (Color) var background_color

var difficulty_multiplier = 1.5
var d_rate = .05

var max_difficulty = 10

func _ready():
	VisualServer.set_default_clear_color(background_color)
	
func _process(delta):
	difficulty_multiplier = clamp(difficulty_multiplier + d_rate*delta,0,max_difficulty)
	#print(difficulty_factor)

func get_difficulty() -> int:
	"""
	Returns whole numbers of difficulty multiplier (1,2,3,4..etc)
	"""
	if difficulty_multiplier - int(difficulty_multiplier) <= 0.02:
		emit_signal("seagulls_stronger")
	return int(difficulty_multiplier)
	
func get_ground() -> Vector2:
	return ground.global_position

	
