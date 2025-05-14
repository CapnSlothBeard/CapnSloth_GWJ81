extends Item

@export var gravity_curve:Curve
const default_curve = preload("res://resources/curves/gravity_curve.tres")

var gravity_curve_default_max_value = 0.0

func _ready():
	gravity_curve_default_max_value = gravity_curve.sample(gravity_curve.max_domain)

func _process(delta):
	if(Input.is_action_pressed("drop")):
		gravity_curve.set_point_value(1, 200.0)
	
	if(Input.is_action_just_released("drop")):
		gravity_curve.set_point_value(1, gravity_curve_default_max_value)


func _on_fire():
	print("derpity")

func _on_equip():
	print("derp fluffy cloud derp on_equip")
	Player.gravity_curve = gravity_curve
	
func _on_dequip():
	Player.gravity_curve = default_curve
