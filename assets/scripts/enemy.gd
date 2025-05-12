class_name Enemy
extends CharacterBody2D


@export var max_hp : int = 10
var hp : int = 10
@export var move_speed : float = 100.0
var effects : Dictionary = {}

func _ready():
	initialize_properties()
	

func _process(delta):
	apply_effects()
	

func initialize_properties():
	hp = max_hp

func apply_effects():
	pass
