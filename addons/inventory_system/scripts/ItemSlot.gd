extends Resource;
class_name ItemSlot;

@export var itemStack:ItemStack = null;
@export var category:ItemCategory = null;
@export var slotId:int = -1;

func IsItemCompatibleWithSlot(item:Item)->bool:
	if category:
		return category.IsCategoryCompatibleWithItem(item);
	return true;

func CanItemBeAddedHere(stack:ItemStack)->bool:
	if IsItemCompatibleWithSlot(stack.item) == false:
		return false;
	elif itemStack.item==null || itemStack.amount<=0:
		return true;
	elif stack.item == itemStack.item && stack.tag == itemStack.tag:
		return itemStack.amount < itemStack.item.maxStackAmount;
	return false;

func CanItemBeDroppedIn(dragData:ItemDragData)->bool:
	if IsItemCompatibleWithSlot(itemStack.item) == false:
		return false;
	elif itemStack.item==null || itemStack.amount<=0:
		return true;
	elif dragData.GetStack().item == itemStack.item && dragData.GetStack().tag == itemStack.tag:
		return itemStack.amount < itemStack.item.maxStackAmount;
	elif dragData.amount == dragData.GetStack().amount: # check if can swap items
		return dragData.slot.IsItemCompatibleWithSlot(dragData.GetItem());
	return false;

func DropIn(dragData:ItemDragData):
	if CanItemBeDroppedIn(dragData) == false:
		return;
	elif itemStack.item==null || itemStack.amount<=0 || (dragData.GetItem() == itemStack.item && dragData.GetStack().tag == itemStack.tag):
		var amount:int = min(dragData.amount, dragData.GetItem().maxStackAmount-itemStack.amount);
		amount = max(amount, 0);
		if amount == 0:
			print("Should not happen? ItemSlot::DropIn{amount==0};  dragData.amount=%d, dragData.GetItem().maxStackAmount=%d, itemStack.amount=%d"%[dragData.amount, dragData.GetItem().maxStackAmount, itemStack.amount]);
			return;
		itemStack.item = dragData.GetStack().item;
		itemStack.amount += amount;
		itemStack.tag = dragData.GetStack().tag;
		dragData.GetStack().amount -= amount;
		dragData.amount -= amount;
		if dragData.GetStack().amount == 0:
			dragData.slot.itemStack.item = null;
	elif dragData.amount == dragData.GetStack().amount: # check if can swap items
		if dragData.slot.IsItemCompatibleWithSlot(dragData.GetItem()):
			var temp = dragData.GetStack()
			dragData.slot.itemStack = itemStack;
			itemStack = temp;
			dragData.amount = 0;

