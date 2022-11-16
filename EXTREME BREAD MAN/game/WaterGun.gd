extends Node2D

signal update_water_count(cur_val,max_val)

var capacity = 50
onready var length = capacity
var turn_speed = 3.3
var shoot_speed = 350
var shoot_rate = .2
onready var shoot_timer = $ShootTimer

var nozzle : Node2D

var water :PackedScene = preload("res://game/water/Water.tscn")

var fire_rate_up = false
var has_water

func _ready():
	nozzle = $Nozzle
	shoot_timer.wait_time = shoot_rate
	yield(get_tree(),"idle_frame") # Late
	update_water()

func _process(delta):
	has_water = false if length <=0 else true
	if Input.is_action_pressed("watergun_left"):
		rotate(-turn_speed * delta)
	if Input.is_action_pressed("watergun_right"):
		rotate(turn_speed * delta)
	if Input.is_action_pressed("watergun_shoot") and fire_rate_up and has_water:
		spray_water(Vector2.RIGHT.rotated(nozzle.global_rotation))
		length -= 1
		fire_rate_up = false

func upgrade_firerate():
	shoot_rate += .1
func upgrade_range():
	pass
func upgrade_capacity():
	capacity += 25

func spray_water(direction : Vector2):
	var water_instance : RigidBody2D = water.instance()
	water_instance.global_position = nozzle.global_position
	get_tree().root.add_child(water_instance)
	water_instance.apply_impulse(nozzle.global_position,direction*shoot_speed)
	update_water()

func refill_water():
	length = capacity
	update_water()
	
func update_water():
	emit_signal("update_water_count",length,capacity)

func _on_ShootTimer_timeout():
	fire_rate_up = true
