extends Node2D

enum ItemControlType {LOADOUT, COMBAT}
@export var default_item_control_mode = ItemControlType.LOADOUT


func start_run():
	print("Starting run!")
	SceneLoader.load_scene("res://scenes/game/interior_world.tscn")
	pass # Replace with function body.


func _on_start_run_door_body_entered(body):
	if(body.name == "Player"):
		start_run()
