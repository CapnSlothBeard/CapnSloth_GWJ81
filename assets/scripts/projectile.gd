extends Node2D

@export var damage : int = 1
var velocity : Vector2 = Vector2.ZERO
@onready var blue_staff_particles = $BlueStaffParticles
@onready var pop_sound = $PopSound

@export var lifetime : float = 5.0

func _ready():
	# Detach particle system for seperated queue freeing
	$TravelSound.play()
	$PopSound.reparent(blue_staff_particles)
	blue_staff_particles.follow_object = self
	blue_staff_particles.reparent($/root)
	

func _process(delta):
	position = position + (velocity * delta)
	
	#if(!$TravelSound.playing): $TravelSound.play()
	
	lifetime = lifetime - delta
	if(lifetime <= 0): pop_projectile()

func hit_something(body):
	#If enemy do damage
	#print("hit")
	pop_projectile()
	

func _on_area_2d_body_entered(body):
	hit_something(body)
	pass # Replace with function body.
	
func pop_projectile():
	# DO SOME ANIMATION OR SPAWNING HERE
	pop_sound.play()
	queue_free()
