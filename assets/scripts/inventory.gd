extends Node2D


var active_slots : Dictionary = {}
var backpack_slots : Array = []

enum ItemControlType {LOADOUT, COMBAT}
@export var item_control_mode = ItemControlType.LOADOUT

var interact_item : Item

	

func _on_player_interact_box_area_entered(area):
	#print("Entered item area of: " + str(get_node(area.get_path()).get_parent().name))
	print("Entered item area of: " + str(area.get_parent().name))
	%InventoryHUD.visible = true
	interact_item = area.get_parent()


func _on_player_interact_box_area_exited(area):
	%InventoryHUD.visible = false
	interact_item = null


func _process(delta):
	items_follow_slots()
	
	if(item_control_mode == ItemControlType.LOADOUT):
		
		# Do pick up item input
		if(interact_item != null):
			if(Input.is_action_just_pressed("equipment_1")):
				attempt_item_equip(0)
			if(Input.is_action_just_pressed("equipment_2")):
				attempt_item_equip(1)
			if(Input.is_action_just_pressed("equipment_3")):
				attempt_item_equip(2)
		else:
			# Do item de-equips
			if(Input.is_action_just_pressed("equipment_1") and active_slots.get(0) != null):
					#dequip_slot(0)
					active_slots.get(0).fire()
			if(Input.is_action_just_pressed("equipment_2") and active_slots.get(1) != null):
					dequip_slot(1)
			if(Input.is_action_just_pressed("equipment_3") and active_slots.get(2) != null):
					dequip_slot(2)
	
	elif(item_control_mode == ItemControlType.COMBAT):
		
		#Do use item input
		if(Input.is_action_pressed("equipment_1") and active_slots.get(0) != null):
				active_slots.get(0).fire()
		if(Input.is_action_pressed("equipment_2") and active_slots.get(1) != null):
				active_slots.get(1).fire()
		if(Input.is_action_pressed("equipment_3") and active_slots.get(2) != null):
				active_slots.get(2).fire()
		pass

func items_follow_slots():
	if(active_slots.get(0) != null): active_slots.get(0).global_position = %ItemSlot_0.global_position
	if(active_slots.get(1) != null): active_slots.get(1).global_position = %ItemSlot_1.global_position
	if(active_slots.get(2) != null): active_slots.get(2).global_position = %ItemSlot_2.global_position
		

func attempt_item_equip(slot:int):
	if(interact_item != null):
		if(active_slots.get(slot) != null):
			return_item_to_shelf(active_slots.get(slot))
		
		#interact_item.item_wielder = %Player
		add_item_to_active_slot(slot, interact_item)
		update_inventory_display(slot)
		return true
	#else:
	return false
	
func update_inventory_display(slot:int):
	if(slot == 0):
		if(active_slots.get(0) != null):
			$InventoryHUD/InventoryDisplay/Slot0/Icon.texture = active_slots.get(0).get_child(0).texture
		else:
			$InventoryHUD/InventoryDisplay/Slot0/Icon.texture = null
	if(slot == 1):
		if(active_slots.get(1) != null):
			$InventoryHUD/InventoryDisplay/Slot1/Icon.texture = active_slots.get(1).get_child(0).texture
		else:
			$InventoryHUD/InventoryDisplay/Slot1/Icon.texture = null
	if(slot == 2):
		if(active_slots.get(2) != null):
			$InventoryHUD/InventoryDisplay/Slot2/Icon.texture = active_slots.get(2).get_child(0).texture
		else:
			$InventoryHUD/InventoryDisplay/Slot2/Icon.texture = null

func add_item_to_active_slot(slot:int, item:Item):
	active_slots.set(slot, item)
	item.equip()
	item.is_active = true
	interact_item = null
	%InventoryHUD.visible = false
	pass
	
func add_item_to_backpack(item:Item):
	pass
	
func return_item_to_shelf(item:Item):
	item.dequip()
	item.is_active = false
	item.position = item.shelf_position
	pass
	
func dequip_slot(slot:int):
	#active_slots.get(slot).item_wielder = null
	return_item_to_shelf(active_slots.get(slot))
	active_slots.set(slot, null)
	update_inventory_display(slot)
