extends Node

onready var player : Node2D = get_tree().get_nodes_in_group('player')[0]
onready var water_gun = player.get_node("WaterGun")
onready var feather_display = $Control/Feathers/Label
onready var water_level = $Control/Water
onready var upgrade_text = $Control/UpgradeText
onready var upgrade_choices = $Control/UpgradeChoices

onready var breads_display = $Control/Breads
onready var breads = []

func _ready():
	player.connect("update_feather_count",self,"change_feather_text")
	player.connect("update_health",self,"change_health")
	water_gun.connect("update_water_count",self,"change_water_text")
	
	yield(get_tree(),"idle_frame") #Late ready
	for child in breads_display.get_children():
		breads.append(child)
	hide_upgrade_choices()
	
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
	
	
