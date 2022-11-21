extends CanvasLayer

onready var player_score = $DeathScreen/Panel/PlayerScore

func _ready():
	hide()

func _on_BreadMan_died():
	show()
	
	
func _on_Replay_pressed():
	#get_tree().change_scene("res://game/SCENES/levels/Level1.tscn")
	var feathers = get_tree().get_nodes_in_group("feather")
	for feather in feathers:
		feather.queue_free()
		
	var seagulls = get_tree().get_nodes_in_group("seagull")
	for seagull in seagulls:
		seagull.queue_free()
		
	get_tree().reload_current_scene()

func _on_BreadMan_update_score(score):
	player_score.text = "Score: "+ str(int(score))
