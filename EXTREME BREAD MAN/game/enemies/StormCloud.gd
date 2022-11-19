extends Node2D

signal strike

onready var sprite = $AnimatedSprite

onready var strike_timer = $StrikeTimer
onready var lifetime_timer = $LifetimeTimer

func _ready():
	sprite.play("strike")

func strike():
	emit_signal("strike")
	sprite.play("default")

func _on_StrikeTimer_timeout():
	strike()


func _on_LifetimeTimer_timeout():
	queue_free()
