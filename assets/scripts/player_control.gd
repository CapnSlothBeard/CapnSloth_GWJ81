extends CharacterBody2D

@export var game_speed = 1.0

@export_category("Stats")

@export var default_hp : int = 4

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

@export var knockback_speed : float = 500.0
@export var knockback_duration : float = 0.1
var knockback_time :float = 1.0

var velocity_multipliers : Dictionary = {}
var velocity_additions : Dictionary = {}

@onready var animation_player = $AnimationPlayer
@onready var player_falling_sound = $PlayerFallingSound
@onready var player_footsteps = $PlayerFootsteps
@export var min_time_between_footstep_sounds : float = 1.0
var time_before_next_footstep : float = 0.0
@onready var player_landing_sound = $PlayerLandingSound
var landed : bool = true

@onready var inventory_hud = %InventoryHUD
@onready var inventory = %Inventory
@onready var item_slot_0 = %ItemSlot_0
@onready var item_slot_1 = %ItemSlot_1
@onready var item_slot_2 = %ItemSlot_2
@onready var player_collision_box = %PlayerCollisionBox
@onready var player_interact_box = %PlayerInteractBox
@onready var player_lamp = %PlayerLamp
@onready var hp_bar = %HPBar


func _ready():
	%HPBar.update_display()

func _process(delta):
	
	# Check knockback stop
	if(velocity_additions.has("knockback")):
		if(knockback_time < knockback_duration): knockback_time += delta
		if(knockback_time >= knockback_duration):
			velocity_additions.erase("knockback")
	#print(velocity.y)
	
	if(is_on_floor()):
		animation_player.stop()
		if(released_jump):
			jump_progress = 0.0
			jump_spent = false
		if(!landed):
			landed = true
			if(!player_landing_sound.playing) : player_landing_sound.play()
	
	if(not is_on_floor()):
		#Gravity
		if(velocity.y < 0): gravity_progress = 0.0
		gravity_progress = gravity_progress + (100 * delta)
		velocity.y = (gravity_curve.sample(gravity_progress)) * game_speed
		landed = false
		
	
	if(Input.is_action_pressed("jump")):
		#print(jump_progress)
		released_jump = false
		if(jump_spent == false):
			if(Input.is_action_just_pressed("jump")): $PlayerJumpSound.play()
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
	if(!velocity_additions.has("knockback")):
		var input_dir = Input.get_vector("move_left", "move_right", "","")
		speed_progress = (speed_progress + (100*delta)) * abs(input_dir.x)
		velocity.x = movespeed_curve.sample(speed_progress)* game_speed * move_speed_mul * input_dir.x
		
		#Play step audio
		if(time_before_next_footstep > 0): time_before_next_footstep = time_before_next_footstep - delta
		if(is_on_floor() and velocity.x != 0 and !player_footsteps.playing and time_before_next_footstep <= 0.01):
			player_footsteps.play()
			time_before_next_footstep = min_time_between_footstep_sounds
	else:
		velocity.x = 0.0
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
	
	# Play falling animation if falling.
	if(velocity.y > 0):
		animation_player.play("falling")
		if(!player_falling_sound.playing): player_falling_sound.play(randf_range(0.0, 6.28))
	else:
		player_falling_sound.stop()
		
	#Apply velocity
	for vel in velocity_additions.values():
		velocity = velocity + vel
	
	for vel in velocity_multipliers.values():
		velocity = velocity * vel
	move_and_slide()
	

#func update_health_display():
	#%HPBar.update_display()

func take_damage(amount:int, damage_causer:Node2D):
	#print("Damage")
	$PlayerHurtSound.play()
	%HPBar.damage_hearts(amount)
	take_knockback(damage_causer.global_position)
	if(%HPBar.full_hearts <= 0):
		hp_is_zero()
		
func hp_is_zero():
	print("ded")
	
func take_knockback(fromPos:Vector2):
	var dir = (global_position - fromPos).normalized()
	dir.y -= 0.25
	dir = dir.normalized()
	velocity_additions.set("knockback", dir * knockback_speed)
	knockback_time = 0.0
