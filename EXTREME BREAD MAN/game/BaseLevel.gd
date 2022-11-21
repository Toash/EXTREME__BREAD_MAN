"""
Contains difficulty, maintains higher order things
that aren't global
"""

extends Node

signal seagulls_stronger

export (Color) var background_color

# 1.1 and not 1 because  if one it says seagulls are stronger on game start
var difficulty_multiplier = 1.1
var d_increase_rate = .04

var max_difficulty = 5

var stronger_cooldown_up = true

func _ready():
	VisualServer.set_default_clear_color(background_color)
	
func _process(delta):
	difficulty_multiplier = clamp(difficulty_multiplier + (d_increase_rate*delta),0,max_difficulty)
	if difficulty_multiplier - int(difficulty_multiplier) <= 0.02:
		if stronger_cooldown_up and difficulty_multiplier!=max_difficulty:
			emit_signal("seagulls_stronger")
			stronger_cooldown_up = false

func get_difficulty_number() -> int:
	"""
	Returns whole numbers of difficulty multiplier (1,2,3,4..etc)
	This multiplier affects things such as seagull attributes. To make game harder 
	As time progresses. 
	"""
	return int(difficulty_multiplier)

func _on_StrongerTimer_timeout():
	stronger_cooldown_up = true
