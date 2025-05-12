extends HBoxContainer

var full_hearts : int = 4
var empty_hearts : int = 0
var deflated_hearts : int = 0
const HEART_ICON_FULL = preload("res://scenes/hud/heart_icon_full.tscn")
const HEART_ICON_EMPTY = preload("res://scenes/hud/heart_icon_empty.tscn")
const HEART_ICON_DEFLATED = preload("res://scenes/hud/heart_icon_deflated.tscn")


func heal_hearts(amount:int):
	empty_hearts -= amount
	full_hearts += amount
	if(empty_hearts < 0) : empty_hearts = 0
	update_display()
	
func damage_hearts(amount:int):
	full_hearts -= amount
	empty_hearts += amount
	if(full_hearts < 0) : full_hearts = 0
	update_display()
	
func deflate_hearts(amount:int):
	deflated_hearts += amount
	full_hearts -= amount
	if(full_hearts < 0) : full_hearts = 0
	update_display()
	
func inflate_hearts(amount:int):
	deflated_hearts -= amount
	full_hearts += amount
	if(deflated_hearts < 0) : deflated_hearts = 0
	update_display()

func update_display():
	#Clear children
	for c in get_children():
		remove_child(c)
		c.queue_free()
	
	# Restock
	for i in full_hearts:
		var h = HEART_ICON_FULL.instantiate()
		add_child(h)
	
	for i in empty_hearts:
		var h = HEART_ICON_EMPTY.instantiate()
		add_child(h)
	
	for i in deflated_hearts:
		var h = HEART_ICON_DEFLATED.instantiate()
		add_child(h)
