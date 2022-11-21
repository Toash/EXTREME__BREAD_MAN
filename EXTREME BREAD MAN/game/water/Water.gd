extends RigidBody2D

onready var area = $Area
onready var water_stream = $stream
onready var splash = $splash
onready var lifetime_timer = $LifetimeTimer
onready var free_timer = $FreeTimer

#Need to queue_free at some point
func _ready():
	lifetime_timer.wait_time = water_stream.lifetime
	lifetime_timer.start()

func _on_lifetime_over():
	global_position = Vector2.DOWN*1000
	free_timer.start()

# Should depend on lifetime of particle?	
func disable_area():
	area.set_deferred("monitoring",false)
	area.set_deferred("monitorable",false)

func splash():
	"""
	Deletes water
	"""
	disable_area()
	water_stream.emitting = false
	splash.emitting = true

func _on_FreeTimer_timeout():
	queue_free()

func _on_Area_area_entered(area):
	splash()


func _on_Area_body_entered(body):
	splash()
