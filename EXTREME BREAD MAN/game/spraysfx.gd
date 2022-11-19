extends AudioStreamPlayer2D

var rng = RandomNumberGenerator.new()

func _on_WaterGun_sprayed_water():
	pitch_scale = 1 + rng.randf_range(0,1)
	play()
