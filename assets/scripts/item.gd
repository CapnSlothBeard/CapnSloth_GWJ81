class_name Item
extends Node2D

@export var shelf_position : Vector2 = Vector2.ZERO
var is_active = false
@onready var area_2d = $Area2D

#var item_wielder : CharacterBody2D


func _process(delta):
	pass
	

# One func for the base class, and one for extending
func fire():
	_on_fire()
func _on_fire():
	pass

func equip():
	area_2d.monitorable = false
	_on_equip()
func _on_equip():
	pass

func dequip():
	area_2d.monitorable = true
	_on_dequip()
func _on_dequip():
	pass
