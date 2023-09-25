extends Resource;
class_name ItemRecipe;

@export var requiredItems:Array[ItemStack] = [];
@export var result:Array[ItemStack] = [];

func DuplicateCraftedResult(count:int)->Array[ItemStack]:
	var ret:Array[ItemStack] = [];
	for s in result:
		var stack:ItemStack = ItemStack.new();
		stack.item = s.item;
		stack.amount = s.amount*count;
		stack.tag = s.tag;
		ret.append(stack);
	return ret;

# returns amount of crafted items
func TryCrafting(source:InventoryStorage, destiny:InventoryStorage, amount:int)->int:
	var crafted:int = 0;
	for i in range(0, amount):
		if TryCraftingSingle(source, destiny):
			++crafted;
		else:
			break;
	return crafted;

# returns amount that can be stored
func CanResultBeStoredIn(inventory:InventoryStorage)->bool:
	return inventory.CanAllBeStored(result);

# returns amount that can be crafted
func CanBeCraftedFrom(inventory:InventoryStorage)->bool:
	for stack in requiredItems:
		if inventory.CountItems(stack) < stack.amount:
			return false;
	return true;

func TryCraftingSingle(source:InventoryStorage, destiny:InventoryStorage)->bool:
	if CanBeCraftedFrom(source) && CanResultBeStoredIn(destiny):
		# no fail safe, due to above checks
		for s in requiredItems:
			var extracted = source.TryExtractItemStack(s, s.amount);
			# is this assert necessary
			assert(extracted.amount==s.amount);
		var craftedResult = DuplicateCraftedResult(1);
		for stack in craftedResult:
			var amount = destiny.TryPutAsMuchItemsAsPossible(stack, stack.amount);
			assert(stack.amount == 0);
		return true;
	return false;
