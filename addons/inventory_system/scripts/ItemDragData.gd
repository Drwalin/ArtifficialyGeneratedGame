extends RefCounted;
class_name ItemDragData;

var itemStack:ItemStack = null;
var amount:int = 0;
var slot:ItemSlot = null;
var storage:InventoryStorage = null;
var canBeSwapped:bool = false;

func _init(_itemStack:ItemStack, _amount:int, _slot:ItemSlot, _storage:InventoryStorage, _canBeSwapped:bool=true)->void:
	slot = _slot;
	amount = _amount;
	storage = _storage;
	itemStack = _itemStack;
	canBeSwapped = _canBeSwapped;

func GetStack()->ItemStack:
	return itemStack;

func GetItem()->Item:
	return itemStack.item;

func CanBeSwapped()->bool:
	return canBeSwapped && slot && storage && amount==itemStack.amount;

