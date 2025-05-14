class_name Enemy
extends CharacterBody2D


@export var max_hp : int = 10
var hp : int = 10
@export var move_speed : float = 100.0
var effects : Dictionary = {}

@export var damage_flash_duration : float = 0.5
var damage_flash_time : float  = 0.0

func _ready():
	initialize_properties()
	

func _process_enemy(delta:float):
	pass

func _process(delta):
	apply_effects()
	
	#Damage flash
	if(damage_flash_time > 0.0):
		damage_flash_time -= delta
		if(damage_flash_time <= 0.0):
			end_damage_flash()
			
			
			
	_process_enemy(delta)

func initialize_properties():
	hp = max_hp

func apply_effects():
	pass
	
func take_damage(amount:int, damage_sender:Node2D):
	start_damage_flash()
	print("damaging enemy")
	
	
func start_damage_flash():
	damage_flash_time = damage_flash_duration
	for s in get_sprites():
		s.modulate = Color(1,0,0)
			
func end_damage_flash():
	for s in get_sprites():
		s.modulate = Color(1,1,1)
	
func get_sprites():
	var sprites : Array = []
	for child in get_children():
		if(child is Sprite2D or child is AnimatedSprite2D):
			sprites.append(child)
	return sprites
