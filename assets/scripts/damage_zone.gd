extends Area2D

@export var damage_amount : int = 1


func _on_body_entered(body):
	if(body.name == "Player"):
		Player.take_damage(damage_amount, self)
