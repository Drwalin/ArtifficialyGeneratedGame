extends Node;
class_name InventoryStorage;

@export var items:Array[ItemStack] = [];
@export var itemCategories:Array[ItemCategory] = [];
@export var expandableInventory:bool = false;
@export var infiniteStacks:bool = false;

func _ready()->void:
	for i in range(0, items.size()):
		if items[i] == null:
			items[i] = ItemStack.new();
	itemCategories.resize(items.size());

func _process(delta:float)->void:
	pass;

func Sort()->void:
	pass;

func IsCategoryCompatible(itemStack:ItemStack, slotId:int)->bool:
	if slotId >= 0 && slotId < itemCategories.size():
		if itemCategories[slotId]:
			return itemCategories[slotId].IsCategoryCompatibleWithItem(itemStack.item);
		return true;
	return true;

func GetSlotIdToDrop(data, invSlot:InventorySlot)->int:
	if invSlot:
		if IsCategoryCompatible(data.GetItemStack(), invSlot.slotId) == false:
			return false;
		if (items[invSlot.slotId].amount == 0 || items[invSlot.slotId].item == null) && IsCategoryCompatible(data.GetItemStack(), invSlot.slotId):
			return invSlot.slotId;
		if items[invSlot.slotId].item == data.GetItemStack().item && items[invSlot.slotId].tag == data.GetItemStack().tag:
			if items[invSlot.slotId].amount < items[invSlot.slotId].item.maxStackAmount:
				return invSlot.slotId;
		else: # swap
			if data.amount == data.GetItemStack().amount: # if whole stack was picked
				return invSlot.slotId;
	else:
		for i in range(0, items.size()):
			var it = items[i];
			if it.amount != 0 && it.amount < it.item.maxStackAmount:
				if it.item == data.GetItemStack().item && it.tag == data.GetItemStack().tag:
					return i;
		for i in range(0, items.size()):
			var it = items[i];
			if it.amount == 0 || it.item == null && IsCategoryCompatible(data.GetItemStack(), i):
				return i;
	return -1;


func CanDropIn(data:InventoryDragData, invSlot:InventorySlot)->bool:
	if invSlot == data.inventorySlot:
		return true;
	var slotId = GetSlotIdToDrop(data, invSlot);
	return slotId >= 0;

func DropIn(data, invSlot:InventorySlot)->void:
	if invSlot == data.inventorySlot:
		return;
	var slotId = GetSlotIdToDrop(data, invSlot);
	if slotId < 0:
		return;
	if slotId >= items.size():
		# do expand if available
		return;
	var otherItems = data.GetStorage().items;
	var otherSlotId = data.inventorySlot.slotId;
	
	var stack = items[slotId];
	var otherStack = otherItems[otherSlotId];
	
	if stack.item == otherStack.item && stack.tag == otherStack.tag:
		var maxAmount = stack.item.maxStackAmount;
		var transAmount = min(data.amount, maxAmount-stack.amount);
		stack.amount += transAmount;
		otherStack.amount -= transAmount;
		if otherStack.amount == 0:
			otherStack.item = null;
			otherStack.tag = {};
	else:
		otherItems[otherSlotId] = stack;
		items[slotId] = otherStack;

