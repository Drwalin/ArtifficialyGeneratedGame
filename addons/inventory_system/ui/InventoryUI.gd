extends Control;
class_name InventoryUI;

var storage:InventoryStorage = null;
@onready var slots = $ScrollContainer/GridContainer;

func ConnectToStorage(_storage:InventoryStorage)->void:
	show();
	storage = _storage;
	UpdateItemSlots();

func DisconnectStorage()->void:
	hide();
	var children = slots.get_children();
	for child in children:
		slots.remove_child(child);
	storage = null;

func _ready()->void:
	DisconnectStorage();

func _process(delta:float)->void:
	if visible:
		if storage == null:
			DisconnectStorage()
			hide();
		else:
			UpdateItemSlots();
	elif storage:
		DisconnectStorage();

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
	return storage.CanDropIn(data, null);

func _drop_data(pos:Vector2, data):
	storage.DropIn(data, null);
