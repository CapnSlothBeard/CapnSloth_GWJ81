extends Enemy


var dir_towards_player : Vector2 = Vector2.ZERO
@export var gravity : float = 100.0
var velocity_additions : Array = []
var dash_dir : Vector2 = Vector2.ZERO
@export var dash_speed_mul : float = 4.0
@export var dash_duration : float = 1.2
@export var dash_cooldown : float = 3.0
var dash_cooldown_progress : float = 3.0
@export var dash_activation_distance_from_player : float = 128.0
var dash_time : float = 0.0

@export var attack_cooldown : float = 0.5
var attack_time : float = 0.5
var player_in_danger = false

enum states {SLEEP, WALK, DASH}
var state = states.SLEEP

func _wake():
	state = states.WALK
	$AnimationPlayer.play("idle")

func _process(delta):
	
	for vel in velocity_additions:
		velocity += vel
	velocity_additions.clear()
	move_and_slide()
	
	if(attack_time < attack_cooldown): attack_time += delta
	if(player_in_danger):
		if(attack_time >= attack_cooldown):
			%Player.take_damage(1, self)
			attack_time = 0.0

func _physics_process(delta):
	dir_towards_player =  (%Player.global_position - global_position).normalized()
	
	
	# Gravity
	if(!is_on_floor()):
		velocity_additions.append(Vector2(0,gravity))
	
	if(state == states.WALK):
		velocity.x = dir_towards_player.x * move_speed
		var dist_to_player = global_position.distance_to(%Player.global_position)
		
		# Do dash prep
		if(dash_cooldown_progress > 0):
			dash_cooldown_progress = dash_cooldown_progress - delta
		
		if(dash_cooldown_progress <= 0.01):
			if dist_to_player < dash_activation_distance_from_player:
				start_dash()
		
	elif(state == states.DASH):
		
		if(dash_time > 0):
			dash_time = dash_time - delta
			velocity_additions.clear()
			velocity = dash_dir * move_speed * dash_speed_mul
		elif state == states.DASH:
			end_dash()
		
		
		
		
func start_dash():
	dash_time = dash_duration
	dash_dir = dir_towards_player
	state = states.DASH
	$AnimationPlayer.play("roll")
	
func end_dash():
	state = states.WALK
	$AnimationPlayer.play("idle")
	dash_cooldown_progress = dash_cooldown


func _on_damage_area_body_entered(body):
	
	if(body.name == "Player"):
		player_in_danger = true
		#body.take_damage(1)


func _on_damage_area_body_exited(body):
	if(body.name == "Player"):
		player_in_danger = false
