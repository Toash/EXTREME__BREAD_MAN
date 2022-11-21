extends Node

"""
Hud has to exist in the scene for other nodes to work (such as WaterGunUpgrader)
(bad design)
"""

signal upgrade_range
signal upgrade_firerate
signal upgrade_capacity
signal upgrade_nozzle_count

var player : Node2D 
var water_gun
var level_root 

onready var feather_display = $Control/Feathers/Label
onready var water_level = $Control/Water
onready var upgrade_text = $Control/UpgradeText
onready var upgrade_choices = $Control/UpgradeChoices
onready var soggy_bread = $Control/SoggyBread
onready var hungry_seagulls = $Control/HungrySeagulls
onready var score_display = $Control/Score
onready var maxed = $Control/Maxed
onready var maxed_timer = $Control/Maxed/MaxedTimer

onready var breads_display = $Control/Breads
onready var breads = []

func _ready():

	var players = get_tree().get_nodes_in_group("player")
	level_root = get_tree().get_nodes_in_group("level_root")[0]
	if players.size()>0:
		player = players[0]
		player.connect("update_feather_count",self,"change_feather_text")
		player.connect("update_health",self,"change_health")
		player.connect("just_wet",self,"show_soggy_bread")
		player.connect("just_dried",self,"hide_soggy_bread")
		player.connect("entered_trader",self,"show_upgrade_choices")
		player.connect("exited_trader",self,"hide_upgrade_choices")
		player.connect("update_score",self,"change_score")
		water_gun = player.get_node("WaterGun")
		water_gun. connect("update_water_count",self,"change_water_text")
	level_root.connect("seagulls_stronger",self,"show_hungry_seagulls")
	
	yield(get_tree(),"idle_frame") #Late ready
	
	for child in breads_display.get_children():
		breads.append(child)
	hide_upgrade_choices()
	hide_soggy_bread()
	hide_hungry_seagulls()
	maxed.hide()
	
func change_score(score):
	score_display.text = "Score: " + str(int(score))
	
func hide_hungry_seagulls():
	hungry_seagulls.hide()
func show_hungry_seagulls():
	hungry_seagulls.show()
	$Control/HungrySeagulls/HungrySeagullsTimer.start()

func show_soggy_bread():
	soggy_bread.show()
	
func hide_soggy_bread():
	soggy_bread.hide()

func show_upgrade_choices():
	upgrade_choices.show()
	
func hide_upgrade_choices():
	upgrade_choices.hide()
	
func change_health(amount):
	# This is abyssmal but whatever
	for i in range(len(breads)):
		if i < amount:
			breads[i].show()
		else:
			breads[i].hide()		
			
func change_upgrade_text(new_text):
	upgrade_text.text = new_text
	
func clear_upgrade_text():
	upgrade_text.text = ""

func change_feather_text(new_text):
	var raw_string = ": %s"
	var formatted_string = raw_string % new_text
	feather_display.text = formatted_string
	
func change_water_text(value,max_value):
	var percentage :float = (float(value)/max_value) * 100
	water_level.value = percentage
	
	
func _on_HungrySeagullsTimer_timeout():
	hide_hungry_seagulls()


func _on_upgrade_ranged():
	emit_signal("upgrade_range")


func _on_upgrade_firerate():
	emit_signal("upgrade_firerate")


func _on_upgrade_capacity():
	emit_signal("upgrade_capacity")


func _on_upgrade_multiplier():
	emit_signal("upgrade_nozzle_count")


func _on_WaterGunUpgrader_maxed():
	maxed.show() 
	maxed_timer.start()

func _on_MaxedTimer_timeout():
	maxed.hide()
