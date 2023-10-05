extends Resource;
class_name ItemSlot;

@export var itemStack:ItemStack = ItemStack.new();
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
	elif stack.IsSame(itemStack):
		return itemStack.amount < itemStack.item.maxStackAmount;
	return false;

func HowManyCanBeAddedHere(stack:ItemStack)->int:
	if CanItemBeAddedHere(stack):
		if itemStack.IsEmpty():
			return stack.item.maxStackAmount;
		else:
			return max(min(stack.item.maxStackAmount - itemStack.amount, stack.item.maxStackAmount), 0);
	return 0;

func CanItemBeDroppedIn(dragData:ItemDragData)->bool:
	if IsItemCompatibleWithSlot(itemStack.item) == false:
		return false;
	elif itemStack.item==null || itemStack.amount<=0:
		return true;
	elif dragData.GetStack().IsSame(itemStack):
		return itemStack.amount < itemStack.item.maxStackAmount;
	elif dragData.CanBeSwapped():
		return dragData.slot.IsItemCompatibleWithSlot(dragData.GetItem());
	return false;

func DropIn(dragData:ItemDragData):
	if CanItemBeDroppedIn(dragData) == false:
		return;
	elif itemStack.item==null || itemStack.amount<=0 || dragData.GetStack().IsSame(itemStack):
		#var amount:int = min(dragData.amount, dragData.GetItem().maxStackAmount-itemStack.amount);
		var amount:int = min(dragData.amount, HowManyCanBeAddedHere(dragData.itemStack));
		amount = max(amount, 0);
		assert(amount>0, "Should not happen? ItemSlot::DropIn{amount==0};  dragData.amount=%d, dragData.GetItem().maxStackAmount=%d, itemStack.amount=%d"%[dragData.amount, dragData.GetItem().maxStackAmount, itemStack.amount]);
		if itemStack.amount == 0:
			itemStack.item = dragData.GetStack().item;
			itemStack.tag = dragData.GetStack().tag;
			itemStack.amount = amount;
		else:
			itemStack.AddAmount(amount);
		dragData.GetStack().AddAmount(-amount);
		dragData.amount -= amount;
	elif dragData.CanBeSwapped(): # check if can swap items
		if dragData.slot.IsItemCompatibleWithSlot(dragData.GetItem()):
			dragData.GetStack().Swap(itemStack);

