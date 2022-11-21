"""
Heals the player
"""
extends RigidBody2D

func _on_BreadArea_area_entered(area):
	queue_free()
