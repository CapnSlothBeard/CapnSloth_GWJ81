extends PointLight2D

@export var frequency : float = 0.1
var timer : float = 0.0

func _process(delta):
	if timer < frequency:
		timer = timer + delta
	
	if timer >= frequency:
		timer = 0.0
		rotation_degrees = randf_range(-360, 360)
