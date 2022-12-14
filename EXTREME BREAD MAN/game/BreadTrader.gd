extends Area2D

signal entered_breadtrader
signal exited_breadtrader

onready var player = get_tree().get_nodes_in_group("player")[0]
onready var sprite = $AnimatedSprite
onready var dialogue = $Dialogue

func _ready():
	dialogue.hide()

func _process(delta):
	if is_instance_valid(player):
		if player.position.x < position.x:
			sprite.flip_h = false
		else:
			sprite.flip_h = true

func _on_Hitbox_area_entered(area):
	emit_signal("entered_breadtrader")
	dialogue.show()

func _on_Hitbox_area_exited(area):
	#emit_signal("exited_breadtrader")
	dialogue.hide()
