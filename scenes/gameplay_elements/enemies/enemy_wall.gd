extends Enemy

@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var pupil_pivot_point = $AnimatedSprite2D/PupilPivotPoint
@onready var pupil = $AnimatedSprite2D/PupilPivotPoint/Pupil
var pupil_travel_distance : float = 4.0

@export var fire_rate : float = 1.2
var fire_time : float = 0.0
@export var knockback_multiplier : float = 0.4
const ENEMY_PROJECTILE_BLUE = preload("res://scenes/gameplay_elements/enemy_projectile_blue.tscn")
@export var projectile_speed : float = 240.0

func _process_enemy(delta):
	
	
	# Pupil track player.
	var dir_to_player = global_position.direction_to(Vector2(Player.global_position.x, Player.global_position.y))
	pupil.position = pupil_pivot_point.position + (dir_to_player * pupil_travel_distance)
	var angle_to_player = global_position.angle_to(Player.global_position)
	pupil.rotation = angle_to_player
	
	# Firing logic
	if(fire_time < fire_rate): fire_time += delta
	if(fire_time >= fire_rate): _fire_at_player()


func _fire_at_player():
	var projectile = ENEMY_PROJECTILE_BLUE.instantiate()
	projectile.global_position = global_position
	projectile.belongs_to_player = false
	projectile.knockback_multiplier = knockback_multiplier
	var dir:Vector2 = projectile.global_position.direction_to(Player.global_position)
	dir = dir.normalized()
	projectile.velocity = dir * projectile_speed
	$/root.add_child(projectile)
	#print(projectile.global_position)
	$AudioStreamPlayer2D.play()
	
	fire_time = 0.0
	
