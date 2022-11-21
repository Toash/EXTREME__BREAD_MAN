extends KinematicBody2D

signal update_health(amount)
signal update_score(score)
signal update_feather_count(count)

signal jumping

signal just_wet
signal just_dried

signal took_damage
signal died
signal got_bread

signal entered_trader
signal exited_trader

var feather_count = 0

var max_health = 3
onready var cur_health = max_health

var maxSpeed = 200
onready var cur_max_speed = maxSpeed
var acceleration = 1000
var deceleration = 10
var max_jump_power = 450
onready var cur_jump_power = max_jump_power
var jump_cancel_mult = 3
var gravity = 1200
var moveVec = Vector2.ZERO
var inputVec = Vector2.ZERO

onready var score = 0



var canJump = false
var in_trader = false

onready var water_gun = $WaterGun
onready var refill_area = $RefillArea
onready var soggy_timer = $SoggyTimer
onready var sprite = $AnimatedSprite
onready var bread_area = $BreadArea
onready var bread_col = bread_area.get_node("CollisionShape2D")

func _ready():
	yield(get_tree(),"idle_frame") # Late ready
	emit_signal("update_health",cur_health)
	update_feathercount()

func _process(delta):
	if cur_health == max_health:
		bread_col.set_deferred("disabled",true)
	else:
		bread_col.set_deferred("disabled",false)
	get_input()
	add_to_score(delta*10)
	moveVec.x = clamp(moveVec.x,-cur_max_speed,cur_max_speed)
	horizontal_accelerate(delta)
	if inputVec.y<0 and is_on_floor():
		emit_signal("jumping")
		moveVec.y = -cur_jump_power
	# If going up
	if moveVec.y < 0 and !Input.is_action_pressed("jump"):
		moveVec.y += gravity * jump_cancel_mult * delta
	else:
		moveVec.y += gravity * delta
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
	
func remove_feathers(amount) -> bool:
	"""
	Removes feathers
	Returns true if successful
	Returns false if not
	"""
	if feather_count<amount:
		return false
	else:
		feather_count -= amount
		update_feathercount()
		return true
	
func add_to_score(amount):
	score += amount
	emit_signal("update_score",score)

func get_watergun() -> Node2D:
	return water_gun
	
func get_input():
	inputVec.x = Input.get_action_strength("right")-Input.get_action_strength("left")
	inputVec.y = -Input.get_action_strength("jump")
func horizontal_accelerate(delta):
	moveVec.x += inputVec.x*acceleration*delta
func decelerate(delta):
	moveVec.x = lerp(moveVec.x,0,deceleration * delta)
	
func animate():
	if is_on_floor():
		sprite.animation = 'idle'
	else:
		sprite.animation = 'jump'
	if moveVec.x < 0:
		sprite.flip_h = true
	else:
		sprite.flip_h = false
		
func wet():
	if soggy_timer.is_stopped():
		cur_max_speed /= 2
		cur_jump_power /= 1.4
	soggy_timer.start()
	emit_signal("just_wet")

func dry():
	cur_max_speed = maxSpeed
	cur_jump_power = max_jump_power
	emit_signal("just_dried")
	
func increase_health(amount):
	if amount < 0:
		emit_signal("took_damage")
	cur_health = clamp(cur_health + amount,0,max_health)
	emit_signal("update_health",cur_health)
	if cur_health <= 0:
		die()
		
func die():
	call_deferred("queue_free")
	emit_signal("died")
	emit_signal("update_score",score)

func update_feathercount():
	emit_signal("update_feather_count",feather_count)

func _on_feather_entered(body):
	feather_count += 1
	update_feathercount()
	body.queue_free()
	
func _on_StormCloudArea_area_entered(area):
	wet()

func _on_SoggyTimer_timeout():
	dry()

func _on_TraderArea_area_entered(area):
	emit_signal("entered_trader")
	in_trader = true

func _on_TraderArea_area_exited(area):
	emit_signal("exited_trader")
	in_trader = false 

func _on_BreadArea_area_entered(area):
	emit_signal("got_bread")
	increase_health(1)
