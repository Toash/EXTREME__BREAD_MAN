extends Node2D

signal maxed
signal upgraded

var firerate_cost = 5
var range_cost = 5
var capacity_cost = 5

var firerate_upgrade = -.03
var range_upgrade = 50
var capacity_upgrade = 100

var min_firerate = 0.033
var max_range = 500
var max_capacity = 500

#Sprites
var magazine : Node2D
var barrel : Node2D

var hud
var player
var water_gun : WaterGun

func _ready():
	#Late ready, called before every _process
	yield(get_tree(),"idle_frame") 
	var players = get_tree().get_nodes_in_group("player")
	if players.size()>0:
		player = players[0]
		water_gun = player.get_watergun()
		magazine = water_gun.get_magazine()
		barrel = water_gun.get_barrel()
	else:
		printerr("WaterGunUpgrader in scene but cannot find player!")
		
	hud = get_tree().get_nodes_in_group("hud")[0]
	
	hud.connect("upgrade_range",self,"upgrade_range")
	hud.connect("upgrade_firerate",self,"upgrade_firerate")
	hud.connect("upgrade_capacity",self,"upgrade_capacity")

func upgrade_firerate():
	if water_gun.shoot_rate == min_firerate:
		emit_signal("maxed")
		return
	if player.remove_feathers(firerate_cost):
		emit_signal("upgraded")
		water_gun.shoot_rate = clamp(water_gun.shoot_rate + firerate_upgrade, min_firerate,water_gun.shoot_rate)
		increase_barrel_size(0,0.1)

func upgrade_range():
	if water_gun.shoot_speed == max_range:
		emit_signal("maxed")
		return
	if player.remove_feathers(range_cost):
		emit_signal("upgraded")
		water_gun.shoot_speed = clamp(water_gun.shoot_speed + range_upgrade,0,max_range)
		increase_barrel_size(0.1,0)
	
func upgrade_capacity():
	if water_gun.water_capacity == max_capacity:
		emit_signal("maxed")
		return
	if player.remove_feathers(capacity_cost):
		emit_signal("upgraded")
		water_gun.water_capacity = clamp(water_gun.water_capacity + capacity_upgrade, 0, max_capacity)
		increase_magazine_size(0.1,0.1)
		
func increase_barrel_size(x:float,y:float):
	barrel.scale.x += x
	barrel.scale.y += y
func increase_magazine_size(x:float,y:float):
	magazine.scale.x += x
	magazine.scale.y += y
	
