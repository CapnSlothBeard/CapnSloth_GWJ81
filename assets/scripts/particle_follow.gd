extends GPUParticles2D

@export var follow_object : Node2D
@export var afterlife_time : float = 2.0

func _process(delta):
	if(follow_object != null):
		global_position = follow_object.global_position
	else:
		emitting = false
		afterlife_time = afterlife_time - delta
		if(afterlife_time <= 0):
			queue_free()
