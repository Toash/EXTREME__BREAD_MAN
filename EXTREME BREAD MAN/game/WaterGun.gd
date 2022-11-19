extends Node2D

class_name WaterGun

signal update_water_count(cur_val,max_val)
signal sprayed_water

var water_capacity = 20
onready var water_length = water_capacity
var water_regen_rate = 2.5

var shoot_speed = 350
var shoot_rate = .25
onready var shoot_timer = $ShootTimer
onready var sprite = $Sprite

var turning_with_arrows : bool  = false
var mouse_pos : Vector2
var turn_speed = 3.6

onready var nozzle = $Sprite/Nozzle
onready var cached_pos = position

var water :PackedScene = preload("res://game/water/Water.tscn")

var fire_rate_up = false
var has_water

func _ready():
	shoot_timer.wait_time = shoot_rate
	yield(get_tree(),"idle_frame") # Late
	update_water()

func _process(delta):
	mouse_pos = get_global_mouse_position()
	has_water = false if water_length <=0 else true
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
	elif Input.is_action_pressed("watergun_shoot") and fire_rate_up:
		#TODO: NO AMMO!
		pass
	else:
		regen_water(delta)
	animate()

func animate():
	if ((global_rotation > PI/2) or (global_rotation < -PI/2)):
		sprite.scale.y = -1
		sprite.position.y = -cached_pos.y
	else:
		sprite.scale.y = 1
		sprite.position = cached_pos

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


func _on_ShootTimer_timeout():
	fire_rate_up = true

