extends KinematicBody2D

signal attack
signal flying_away
signal evading

signal hit_bread 
signal hit_water

var points_on_death = 10
var max_health = 0
var cur_health = 0
var speed = 80
var drift_speed = 80

var is_homing

var player 
onready var target_node : Node2D
var go_dir = Vector2.ZERO

#Root always going to be parent
var level_root

onready var sprite = $AnimatedSprite

onready var envir_area = $EnvironmentArea
onready var player_area = $PlayerArea
onready var water_area = $WaterArea

onready var feather = preload("res://game/feather/Feather.tscn")

var rng = RandomNumberGenerator.new()

func _ready():
	if get_tree().get_nodes_in_group("level_root").size()>0:
		level_root = get_tree().get_nodes_in_group("level_root")[0]
	sprite.animation = "flying"
	yield(get_tree(),"idle_frame")
	
	var players = get_tree().get_nodes_in_group("player")
	if players.size()>0:
		player = get_tree().get_nodes_in_group("player")[0]
	strongify()

	
func _process(delta):
	animate()

func _physics_process(delta):
	go_towards_go_dir(delta)
	drift_towards_target(delta)
	
func strongify():
	match (level_root.get_difficulty_number()):
		1:
			speed = 80
			drift_speed = 60
			max_health = 2
		2:
			speed = 120
			drift_speed = 80
			max_health = 3
		3:
			speed = 140
			drift_speed = 90 
			max_health = 4
		4:
			speed = 160
			drift_speed = 100
			max_health = 6
		5:
			speed = 180
			drift_speed = 115
			max_health = 8
		_:
			printerr("Invalid difficulty!")
	cur_health = max_health # Update cur health to new max health

func set_target(tar,drifing:bool):
	self.is_homing = drifing
	if is_instance_valid(tar) or tar is Vector2:
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
	if is_instance_valid(player):
		player.add_to_score(points_on_death)
	fly_away()
	call_deferred("free_colliders")
	call_deferred("drop_feather")
	
# Pick random point in a cone pointing up, go there.
# Going to have to rewrite some code to implement this 
# Make sure seagull cannot be hit again
func fly_away():
	"""
	Flys away to narnia
	"""
	emit_signal("flying_away")
	var narnia = Node2D.new()
	get_tree().root.add_child(narnia)
	var random_angle = rng.randf_range(-PI/6,PI/6)
	var random_dir = Vector2.UP.rotated(random_angle)
	narnia.global_position = position+(random_dir.normalized()*300)
	set_target(narnia,false)
	
func evade():
	"""
	Goes away, eventually tries to attack the player again	
	"""
	emit_signal("evading")
	var tar = Node2D.new()
	get_tree().root.add_child(tar)
	var random_angle = rng.randf_range(-PI/6,PI/6)
	var random_dir = Vector2.UP.rotated(random_angle)
	tar.global_position = position+(random_dir.normalized()*300)
	set_target(tar,false)
	
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
	
func attack(body):
	emit_signal("attack")
	body.increase_health(-1)	
	
func _on_environment_entered(body):
	evade()

func _on_enter_player(body):
	attack(body)
	evade()

func _on_DespawnTimer_timeout():
	queue_free()

func _on_WaterArea_area_entered(area):
	emit_signal("hit_water")
	subtract_health(1)

func _on_ComebackTimer_timeout():
	set_target(player,true)

func _on_AttackTimer_timeout():
	if is_instance_valid(self):	
		if is_instance_valid(player_area):
			player_area.call_deferred("collider_enabled",true)
