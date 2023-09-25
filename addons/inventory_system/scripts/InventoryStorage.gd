extends Node;
class_name InventoryStorage;

@export var slots:Array[ItemSlot] = [];
@export var canDropOnGround:bool = true;

func _ready()->void:
	Expand(slots.size());

func CountItems(stack:ItemStack)->int:
	var count:int = 0;
	for s in slots:
		var i:ItemStack = s.itemStack;
		if stack.IsSame(i):
			count += i.amount;
	return count;

func CanAllBeStored(stacks:Array[ItemStack])->bool:
	var amounts:Array[int] = [];
	for stack in stacks:
		amounts.append(stack.amount);
	for s in slots:
		if !s.itemStack.IsEmpty():
			for i in range(0, stacks.size()):
				var toAdd = s.HowManyCanBeAddedHere(stacks[i]);
				if toAdd > 0:
					amounts[i] -= min(amounts[i], toAdd);
					break;
	for s in slots:
		if s.itemStack.IsEmpty():
			for i in range(0, stacks.size()):
				var toAdd = s.HowManyCanBeAddedHere(stacks[i]);
				if toAdd > 0:
					amounts[i] -= min(amounts[i], toAdd);
					break;
	for a in amounts:
		if a>0:
			return false;
	return true;

func CountFreeSlotsFor(stack:ItemStack)->int:
	var count:int = 0;
	for s in slots:
		var i:ItemStack = s.itemStack;
		if i.IsEmpty() && s.CanItemBeAddedHere(stack):
			count += 1;
	return count;

func TryExtractItemStack(stack:ItemStack, amount:int)->ItemStack:
	if CountItems(stack) < amount:
		return null;
	var itemStack:ItemStack = ItemStack.new();
	var leftToExtract:int = amount;
	for s in slots:
		if leftToExtract == 0:
			break;
		var i:ItemStack = s.itemStack;
		if stack.IsSame(i):
			leftToExtract -= i.TransferTo(itemStack, leftToExtract, true);
	return itemStack;

func ExtractItemStack(stack:ItemStack, amount:int)->ItemStack:
	if CountItems(stack) <= amount:
		return null;
	return TryExtractItemStack(stack, amount);

func CountFreeSpaceFor(stack:ItemStack, ignoreFreeSlots:bool)->int:
	var count:int = 0;
	for s in slots:
		var i:ItemStack = s.itemStack;
		if stack.IsSame(i):
			count += stack.item.maxStackAmount-i.amount;
		elif ignoreFreeSlots && i.IsEmpty() && s.CanItemBeAddedHere(stack):
			count += stack.item.maxStackAmount;
	return count;

func TryPutAsMuchItemsAsPossible(stack:ItemStack, amount:int)->int:
	assert(stack.amount >= amount);
	var count:int = 0;
	for s in slots:
		if count == 0:
			return count;
		var it:ItemSlot = s;
		if it.itemStack.amount != 0 && it.itemStack.amount < it.itemStack.item.maxStackAmount:
			if it.CanItemBeAddedHere(stack):
				count += stack.TransferTo(it.itemStack, amount-count, false);
	for s in slots:
		if count == 0:
			return count;
		var it:ItemSlot = s;
		if it.CanItemBeAddedHere(stack):
			count += stack.TransferTo(it.itemStack, amount-count, false);
	return count;

func Expand(newSize:int)->void:
	slots.resize(newSize);
	for i in range(0, slots.size()):
		if !slots[i]:
			slots[i] = ItemSlot.new();
		slots[i].slotId = i;

func _process(delta:float)->void:
	for s in slots:
		if s:
			if s.itemStack:
				s.itemStack.Tick(delta, self);

func GetSlotIdToDrop(dragData:ItemDragData, invSlot:ItemSlot)->int:
	if invSlot:
		if invSlot.CanItemBeDroppedIn(dragData):
			return invSlot.slotId;
	else: # if no item slot specified, find any that applies
		for i in range(0, slots.size()):
			var it:ItemSlot = slots[i];
			if it.itemStack.amount != 0 && it.itemStack.amount < it.itemStack.item.maxStackAmount:
				if it.CanItemBeAddedHere(dragData.GetStack()):
					return i;
		for i in range(0, slots.size()):
			var it = slots[i];
			if it.CanItemBeAddedHere(dragData.GetStack()):
				return i;
	return -1;


func CanDropIn(dragData:ItemDragData, invSlot:ItemSlot)->bool:
	if invSlot == dragData.slot:
		return false;
	if invSlot == null && self == dragData.storage:
		return false;
	var slotId = GetSlotIdToDrop(dragData, invSlot);
	return slotId >= 0;

func DropIn(dragData:ItemDragData, invSlot:ItemSlot)->void:
	if invSlot == dragData.slot:
		return;
	while dragData.amount > 0:
		var slotId = GetSlotIdToDrop(dragData, invSlot);
		if slotId < 0:
			#@TODO: expand storage if needed and possible here
			return;
		slots[slotId].DropIn(dragData);
		invSlot = null;
		if self == dragData.storage:
			return;

