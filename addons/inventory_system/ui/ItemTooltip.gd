extends VBoxContainer;

func Set(itemStack:ItemStack, inventoryStorage:InventoryStorage)->void:
	var item = itemStack.item;
	%Amount.text = "%d/%d" % [itemStack.amount, item.maxStackAmount];
	%Name.text = item.fullName;
	item.SetDescription(%Description, itemStack);

func _ready()->void:
	pass;

func _process(delta:float)->void:
	pass;
