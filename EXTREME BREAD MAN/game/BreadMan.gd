extends KinematicBody2D

signal update_health(amount)
signal died
signal update_feather_count(count)
signal got_bread

var max_health = 3
onready var cur_health = max_health

var maxSpeed = 200
onready var cur_max_speed = maxSpeed
var acceleration = 1000
var deceleration = 10
var jumpPower = 350
var gravity = 1200
var moveVec = Vector2.ZERO
var inputVec = Vector2.ZERO

var feather_count = 0

var canJump = false

onready var water_gun = $WaterGun
onready var refill_area = $RefillArea
onready var soggy_timer = $SoggyTimer

func _ready():
	yield(get_tree(),"idle_frame") # Late ready
	emit_signal("update_health",cur_health)
	emit_signal("update_feather_count",feather_count)

func _process(delta):
	get_input()
	moveVec.x = clamp(moveVec.x,-cur_max_speed,cur_max_speed)
	horizontal_accelerate(delta)
	if inputVec.y<0 and is_on_floor():
		moveVec.y = -jumpPower
	applyGravity(delta)
	if is_on_floor():
		canJump = true
	if inputVec.x == 0:
		decelerate(delta)	
	animate()
func _physics_process(_delta):
	moveVec = self.move_and_slide(moveVec,Vector2.UP)
	if refill_area.get_overlapping_areas().size()>0:
		if Input.is_action_just_pressed("interact"):
			water_gun.refill_water()
	
func get_water_gun() -> Node2D:
	return water_gun
	
func get_input():
	inputVec.x = Input.get_action_strength("right")-Input.get_action_strength("left")
	inputVec.y = -Input.get_action_strength("jump")
func horizontal_accelerate(delta):
	moveVec.x += inputVec.x*acceleration*delta
func decelerate(delta):
	moveVec.x = lerp(moveVec.x,0,deceleration * delta)
func applyGravity(delta):
	moveVec.y += gravity * delta
func animate():
	if is_on_floor():
		$AnimatedSprite.animation = 'idle'
	else:
		$AnimatedSprite.animation = 'jump'
	if moveVec.x < 0:
		$AnimatedSprite.flip_h = true
	else:
		$AnimatedSprite.flip_h = false
		
func soggify():
	if soggy_timer.is_stopped():
		cur_max_speed /= 2
	soggy_timer.start()
	

func take_damage(amount):
	cur_health -= amount
	emit_signal("update_health",cur_health)
	print(cur_health)
	if cur_health <= 0:
		die()
		
func die():
	call_deferred("queue_free")
	get_tree().call_deferred("reload_current_scene")
	emit_signal("died")

func _on_feather_entered(body):
	feather_count += 1
	emit_signal("update_feather_count",feather_count)
	body.queue_free()
	

func _on_StormCloudArea_area_entered(area):
	soggify()


func _on_SoggyTimer_timeout():
	cur_max_speed = maxSpeed
