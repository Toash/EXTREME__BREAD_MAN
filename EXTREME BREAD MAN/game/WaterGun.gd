extends Node2D

"""
Always attached to player, cannot exist without it (bad design)
"""

class_name WaterGun

signal update_water_count(cur_val,max_val)
signal sprayed_water

var water_capacity = 20
onready var water_length = water_capacity 
onready var water_regen_rate = water_capacity / 6

var shoot_speed = 350
var shoot_rate = .25
onready var sprite = $Sprite

var turning_with_arrows : bool  = false
var mouse_pos : Vector2
var turn_speed = 3.6

onready var nozzle = $Sprite/Nozzle
onready var cached_pos = position

var water :PackedScene = preload("res://game/water/Water.tscn")

var fire_rate_up = false
var has_water

var shoot_process_timer : float = 0

func _ready():
	yield(get_tree(),"idle_frame") # Late
	update_water()

func _process(delta):
	update_shoot_timer(delta)
	water_regen_rate = water_capacity / 6 # This should be done when water_capacity changes
	
	mouse_pos = get_global_mouse_position()
	has_water = false if water_length <=0 else true
	fire_rate_up = true if shoot_process_timer>=shoot_rate else false
	if turning_with_arrows:
		if Input.is_action_pressed("watergun_left"):
			rotate(-turn_speed * delta)
		if Input.is_action_pressed("watergun_right"):
			rotate(turn_speed * delta)
	else:
		look_at(mouse_pos)
	if Input.is_action_pressed("watergun_shoot") and fire_rate_up and has_water:
		spray_water()
		water_length -= 1
		fire_rate_up = false
		reset_shoot_timer()
		
	elif !Input.is_action_pressed("watergun_shoot"):
		regen_water(delta)
	animate()

func animate():
	if ((global_rotation > PI/2) or (global_rotation < -PI/2)):
		sprite.scale.y = -1
		sprite.position.y = -cached_pos.y
	else:
		sprite.scale.y = 1
		sprite.position = cached_pos

func get_magazine()-> Node2D:
	return $Sprite/Magazine as Node2D
	
func get_barrel()-> Node2D:
	return $Sprite/Barrel as Node2D
	

func spray_water():
	emit_signal("sprayed_water")
	var water_instance : RigidBody2D = water.instance()
	get_tree().root.add_child(water_instance)
	water_instance.global_position = nozzle.global_position
	water_instance.apply_impulse(nozzle.global_position,Vector2.RIGHT.rotated(nozzle.global_rotation)*shoot_speed)
	update_water()
	
func regen_water(delta):
	water_length = clamp(water_length + (water_regen_rate*delta),0,water_capacity)
	update_water()
	
#Obsolete, water auto regens
func refill_water():
	water_length = water_capacity
	update_water()
	
func update_water():
	emit_signal("update_water_count",water_length,water_capacity)

func update_shoot_timer(delta):
	shoot_process_timer+=delta
func reset_shoot_timer():
	shoot_process_timer = 0


