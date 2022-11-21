extends CPUParticles2D


func _ready():
	emitting = false

	

func _on_StormCloud_strike():
	emitting = true
