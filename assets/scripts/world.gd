extends Node2D

enum ItemControlType {LOADOUT, COMBAT}
@export var default_item_control_mode = ItemControlType.LOADOUT


func _ready():
	Player.player_lamp.energy = 0.1

func start_run():
	print("Starting run!")
	%Player_Spawnpoint.hide_player()
	SceneLoader.load_scene("res://scenes/game/interior_world.tscn")
	pass # Replace with function body.


func _on_start_run_door_body_entered(body):
	if(body.name == "Player"):
		start_run()
