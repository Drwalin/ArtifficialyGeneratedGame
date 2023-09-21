extends RefCounted;
class_name ItemDragData;

var amount:int = 0;
var slot:ItemSlot = null;
var storage:InventoryStorage = null;

func _init(_slot:ItemSlot, _storage:InventoryStorage, _amount:int)->void:
	amount = _amount;
	slot = _slot;
	storage = _storage;

func GetStack()->ItemStack:
	return slot.itemStack;

func GetItem()->Item:
	return slot.itemStack.item;

