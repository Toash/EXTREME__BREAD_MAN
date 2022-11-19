extends AnimatedSprite

onready var cached_modulate = modulate

func _on_BreadMan_just_wet():
	modulate = Color.gray

func _on_BreadMan_just_dried():
	modulate = cached_modulate
