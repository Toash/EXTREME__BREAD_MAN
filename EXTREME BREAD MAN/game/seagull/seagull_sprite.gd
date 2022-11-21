extends AnimatedSprite



func _on_Seagull_hit_water():
	modulate = Color.gray

func _on_Seagull_flying_away():
	animation = "flee"
