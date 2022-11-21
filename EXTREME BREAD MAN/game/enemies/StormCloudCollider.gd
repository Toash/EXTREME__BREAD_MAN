extends CollisionShape2D


func _ready():
	set_deferred("disabled",true)
	

func _on_StormCloud_strike():
	set_deferred("disabled",false)
