extends Control;
class_name InventoryUI;

var storage:InventoryStorage;
@onready var slots = %GridContainer;
@onready var color = %ColorRect;
@onready var scroll = %ScrollContainer;

func _process(delta:float)->void:
	UpdateItemSlots();
	color.size = scroll.size;

func UpdateItemSlots()->void:
	if slots.get_children().size() < storage.slots.size():
		for i in range(slots.get_children().size(), storage.slots.size()):
			var slot = load("res://addons/inventory_system/ui/InventorySlot.tscn").instantiate();
			slots.add_child(slot);
			slot.inventoryUI = self;
			slot.slotId = i;
	elif slots.get_children().size() > storage.slots.size():
		var s = [];
		var ch = slots.get_children();
		for i in range(storage.items.size(), ch.size()):
			s.append(ch[i]);
		for c in ch:
			slots.remove_child(ch);



func _can_drop_data(pos:Vector2, data)->bool:
	if data is ItemDragData:
		return storage.CanDropIn(data, null);
	return false;

func _drop_data(pos:Vector2, data):
	if data is ItemDragData:
		storage.DropIn(data, null);
