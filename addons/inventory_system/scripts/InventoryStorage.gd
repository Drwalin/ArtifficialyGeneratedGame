extends Node;
class_name InventoryStorage;

@export var slots:Array[ItemSlot] = [];

func _ready()->void:
	Expand(slots.size());

func Expand(newSize:int)->void:
	slots.resize(newSize);
	for i in range(0, slots.size()):
		if slots[i] == null:
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
			#@TODO: expand if needed here
			return;
		slots[slotId].DropIn(dragData);
		invSlot = null;
		if self == dragData.storage:
			return;

