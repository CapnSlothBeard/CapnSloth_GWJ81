extends Node2D

enum ItemControlType {LOADOUT, COMBAT}
@export var spawn_with_item_control_mode = ItemControlType.COMBAT

func _ready():
	spawn_player()

func spawn_player(offset:Vector2 = Vector2.ZERO):
	Player.global_position = self.global_position + offset
	Player.inventory.item_control_mode = spawn_with_item_control_mode
	Player.set_process(true)
	Player.visible = true
	
func hide_player():
	Player.set_process(false)
	Player.visible = false
