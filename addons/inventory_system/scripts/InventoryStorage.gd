extends Node;
class_name InventoryStorage;

@export var items:Array[ItemStack] = [];
@export var expandableInventory:bool = false;
@export var infiniteStacks:bool = false;

func _ready()->void:
	for i in range(0, items.size()):
		if items[i] == null:
			items[i] = ItemStack.new();

func _process(delta:float)->void:
	pass;

func Sort()->void:
	pass;

func GetSlotIdToDrop(data, invSlot:InventorySlot)->int:
	if invSlot:
		if items[invSlot.slotId].amount == 0 || items[invSlot.slotId].item == null:
			return invSlot.slotId;
		if items[invSlot.slotId].item == data.GetItemStack().item && items[invSlot.slotId].tag == data.GetItemStack().tag:
			if items[invSlot.slotId].amount < items[invSlot.slotId].item.maxStackAmount:
				return invSlot.slotId;
		else:
			if data.amount == data.GetItemStack().amount:
				return invSlot.slotId;
	else:
		for i in range(0, items.size()):
			var it = items[i];
			if it.amount != 0 && it.amount < it.item.maxStackAmount:
				if it.item == data.GetItemStack().item && it.tag == data.GetItemStack().tag:
					return i;
		for i in range(0, items.size()):
			var it = items[i];
			if it.amount == 0 || it.item == null:
				return i;
	return -1;


func CanDropIn(data, invSlot:InventorySlot)->bool:
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

