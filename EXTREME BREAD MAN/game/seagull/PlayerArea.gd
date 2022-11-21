extends Area2D

onready var col = $CollisionShape2D

func collider_enabled(enabled:bool):
	if is_instance_valid(self):
		if is_instance_valid(col):
			col.set_deferred("disabled",!enabled)


func _on_Seagull_attack():
	collider_enabled(false)
