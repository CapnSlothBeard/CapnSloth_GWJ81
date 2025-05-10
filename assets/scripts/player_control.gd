extends CharacterBody2D

@export var game_speed = 1.0

@export var movespeed_curve : Curve
var speed_progress = 0.0
@export var move_speed_mul = 1.0

@export var jump_curve: Curve
var jump_progress = 0.0
var jump_spent : bool = false
@export var jump_speed_mul = 1.0
var released_jump = true

@export var gravity_curve : Curve
var gravity_progress = 0.0




func _process(delta):
	
	#print(velocity.y)
	
	if(is_on_floor() and released_jump):
		jump_progress = 0.0
		jump_spent = false
	
	if(not is_on_floor()):
		#Gravity
		if(velocity.y < 0): gravity_progress = 0.0
		gravity_progress = gravity_progress + (100 * delta)
		velocity.y = (gravity_curve.sample(gravity_progress)) * game_speed
	
	if(Input.is_action_pressed("jump")):
		#print(jump_progress)
		released_jump = false
		if(jump_spent == false):
			jump_progress = jump_progress + (100 * delta)
			velocity.y = -(jump_curve.sample(jump_progress) * game_speed * jump_speed_mul)
		if(jump_progress >= jump_curve.max_domain - 0.1):
			#print("Derp")
			jump_spent = true
			jump_progress = 0.0
		#print(velocity)
	if(is_on_ceiling()):
		jump_spent = true
		jump_progress = 0.0
		
	if(Input.is_action_just_released("jump")):
		jump_spent = true
		jump_progress = 0.0
		released_jump = true
		
	
	#Movement
	var input_dir = Input.get_vector("move_left", "move_right", "","")
	speed_progress = (speed_progress + (100*delta)) * abs(input_dir.x)
	velocity.x = movespeed_curve.sample(speed_progress)* game_speed * move_speed_mul * input_dir.x
	
	#if(Input.is_action_pressed("move_right")):
		#print(movespeed_curve.sample(abs(velocity.x) + 1))
	
	
	#if(Input.is_action_pressed("move_left")):
		#velocity.x = -movespeed_curve.sample(abs(velocity.x) + delta) * game_speed * move_speed_mul
		#print(velocity.x)
	#
	#if(Input.is_action_pressed("move_right")):
		#velocity.x = movespeed_curve.sample(abs(velocity.x) + delta) * game_speed * move_speed_mul
		#print(velocity.x)
		#
	
		
	#Apply velocity
	move_and_slide()
	
