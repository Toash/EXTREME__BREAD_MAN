extends CollisionShape2D


func _ready():
	call_deferred("disabled",true)
	

func _on_StormCloud_strike():
	call_deferred("disabled",false)
