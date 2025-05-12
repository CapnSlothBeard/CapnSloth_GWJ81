extends Item

@export var cooldown_time: float = 0.5
var cooldown_progress : float = 0.0

@export var dash_duration: float = 0.06
var dash_time : float = 0.0
@export var dash_speed : float = 800.0
var started_dash = false
var dash_direction : Vector2 = Vector2.ZERO

func _process(delta):
	if(cooldown_progress > 0):
		cooldown_progress = cooldown_progress - delta
		
	if(dash_time > 0):
		dash_time = dash_time - delta
		print("dashing")
	elif started_dash:
		end_dash()

func _on_equip():
	%Player.hp_bar.deflate_hearts(1)

func _on_dequip():
	%Player.hp_bar.inflate_hearts(1)

func start_dash():
	%Player.velocity_additions.set("bag_of_winds_dash", dash_direction * dash_speed)
	started_dash = true
func end_dash():
	%Player.velocity_additions.erase("bag_of_winds_dash")

func _on_fire():
	if(cooldown_progress <= 0.0):
		$AudioStreamPlayer2D.play()
		# Do dash
		dash_time = dash_duration
		cooldown_progress = cooldown_time
		#dash_direction = %Player.velocity.normalized()
		dash_direction = Input.get_vector("move_left", "move_right", "jump", "drop")
		start_dash()
