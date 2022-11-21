extends Node



func _on_Start_pressed():
	get_tree().change_scene("res://game/SCENES/levels/Story.tscn")


func _on_Tutorial_pressed():
	get_tree().change_scene("res://game/SCENES/Tutorial.tscn")
