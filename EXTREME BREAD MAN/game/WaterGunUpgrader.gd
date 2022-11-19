extends Node2D

var max_range = 400
var max_capacity = 500

var hud
var player
var water_gun : WaterGun

func _ready():
	#Late ready, called before every _process
	yield(get_tree(),"idle_frame") 
	player = get_tree().get_nodes_in_group("player")[0]
	hud = get_tree().get_nodes_in_group("hud")[0]
	water_gun = player.get_watergun();
	
	hud.connect("upgrade_range",self,"upgrade_range")
	hud.connect("upgrade_firerate",self,"upgrade_firerate")
	hud.connect("upgrade_capacity",self,"upgrade_capacity")
	hud.connect("upgrade_nozzle_count",self,"upgrade_nozzle_count")

func upgrade_firerate():
	water_gun.shoot_rate = clamp(water_gun.shoot_rate - .05, 0.02,water_gun.shoot_rate)
	print("upgrading firerate")

func upgrade_range():
	water_gun.shoot_speed = clamp(water_gun.shoot_speed + 100,0,max_range)
	
func upgrade_capacity():
	water_gun.water_capacity = clamp(water_gun.water_capacity, 0, max_capacity)

func upgrade_nozzle_count():
	water_gun.add_new_nozzle()
	pass
	
