extends Node2D

enum ItemControlType {LOADOUT, COMBAT}
@export var default_item_control_mode = ItemControlType.LOADOUT


func start_run():
	print("Starting run!")
	SceneLoader.load_scene("res://scenes/menus/main_menu/main_menu_with_animations.tscn")
	pass # Replace with function body.


func _on_start_run_door_body_entered(body):
	start_run()
