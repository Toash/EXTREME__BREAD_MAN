extends KinematicBody2D

# Seagull goes to target, thats it

signal hit_bread 
signal hit_water

var points_on_death = 100
var max_health = 2 
onready var cur_health = max_health
var speed = 80
var drift_speed = 80

var is_homing

var player 
onready var target_node : Node2D
var go_dir = Vector2.ZERO

onready var sprite = $AnimatedSprite

onready var envir_area = $EnvironmentArea
onready var player_area = $PlayerArea
onready var water_area = $WaterArea

onready var despawn_timer = $DespawnTimer

onready var feather = preload("res://game/feather/Feather.tscn")

func _ready():
	sprite.animation = "flying"
	yield(get_tree(),"idle_frame")
	player = get_tree().get_nodes_in_group("player")[0]
	
func _process(delta):
	animate()

func _physics_process(delta):
	go_towards_go_dir(delta)
	drift_towards_target(delta)

func set_target(tar,homing:bool):
	self.is_homing = homing
	if tar is Node2D:
		target_node = tar
	elif tar is Vector2:
		target_node = Node2D.new()
		get_tree().root.add_child(target_node)
		target_node.global_position = tar
	else:
		printerr("Invalid type")

	go_dir = global_position.direction_to(target_node.global_position)

func subtract_health(amount):
	cur_health -= amount
	if cur_health<=0:
		die()

func die():
	player.add_to_score(points_on_death)
	emit_signal("hit_water")
	fly_away()
	call_deferred("free_colliders")
	call_deferred("drop_feather")
	
# Pick random point in a cone pointing up, go there.
# Going to have to rewrite some code to implement this 
# Make sure seagull cannot be hit again
func fly_away():
	sprite.animation = "flee"
	var narnia = Node2D.new()
	get_tree().root.add_child(narnia)
	narnia.global_position = position+(Vector2.UP * 100)
	set_target(narnia,false)
	despawn_timer.start()
	
func drop_feather():
	var feather_instance = feather.instance()
	feather_instance.global_position = self.global_position
	get_tree().root.add_child(feather_instance)
	
func go_towards_go_dir(delta):
	move_and_collide(go_dir*speed*delta)

func drift_towards_target(delta):
	if is_instance_valid(target_node):
		var drift_vec : Vector2
		if target_node.global_position.x > global_position.x:
			drift_vec = Vector2.RIGHT
		else:
			drift_vec = Vector2.LEFT
		move_and_collide(drift_vec * drift_speed*delta)
	else:
		return
func animate():
	if is_instance_valid(target_node):
		if target_node.global_position.x > global_position.x+40:
			sprite.flip_h = false
		elif target_node.global_position.x < global_position.x-40:
			sprite.flip_h = true
	else:
		return
			
func free_colliders():
	envir_area.queue_free()
	player_area.queue_free()
	water_area.queue_free()
	
func _on_environment_entered(body):
	fly_away()

func _on_water_entered(body):
	subtract_health(1)

func _on_enter_player(body):
	body.change_health(1)

func _on_DespawnTimer_timeout():
	queue_free()
