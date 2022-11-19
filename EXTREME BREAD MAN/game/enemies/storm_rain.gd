extends CPUParticles2D


func _ready():
	emitting = true
	hide()
	

func _on_StormCloud_strike():
	show()
