extends RigidBody2D

onready var collider = $CollisionShape2D
onready var water_stream = $stream
onready var splash = $splash
onready var lifetime_timer = $LifetimeTimer
onready var free_timer = $FreeTimer

#Need to queue_free at some point
func _ready():
	lifetime_timer.wait_time = water_stream.lifetime

func _on_lifetime_over():
	global_position = Vector2.DOWN*1000
	free_timer.start()

# Should depend on lifetime of particle?	
func disable_collider():
	collider.set_deferred("disabled",true)

func splash():
	"""
	Deletes water
	"""
	disable_collider()
	water_stream.emitting = false
	splash.emitting = true

func _on_FreeTimer_timeout():
	queue_free()

func _on_SeagullArea_area_entered(area):
	splash()
