extends Item

const PROJECTILE_BLUE_STAFF = preload("res://scenes/gameplay_elements/projectile_blue_staff.tscn")
@export var cooldown_time : float = 1.0
var cooldown_progress : float = 0.0
@export var projectile_speed : float = 100.0

func _process(delta):
	if(cooldown_progress > 0):
		cooldown_progress = cooldown_progress - delta
	
	

func _on_fire():
	if(cooldown_progress <= 0.0):
		#print("pew pew")
		
		var projectile = PROJECTILE_BLUE_STAFF.instantiate()
		projectile.global_position = Player.global_position
		var dir:Vector2 = get_global_mouse_position() - Player.global_position
		dir = dir.normalized()
		projectile.velocity = dir * projectile_speed
		$/root.add_child(projectile)
		#print(projectile.global_position)
		$AudioStreamPlayer2D.play()
		
		cooldown_progress = cooldown_time
	
