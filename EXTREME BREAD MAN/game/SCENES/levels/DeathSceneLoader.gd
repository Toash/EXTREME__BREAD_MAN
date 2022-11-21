extends Node2D

func _on_BreadMan_died():
	get_tree().change_scene("res://game/SCENES/DeathScreen.tscn")
