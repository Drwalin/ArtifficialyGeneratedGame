extends Control;

@onready var colorRect1 = $Color1;
@onready var colorRect2 = $Color2;
@onready var nameLabel = $Container/Title/Name;
@onready var amountLabel = $Container/Title/Amount;
@onready var description = $Container/Description;

func Set(itemStack:ItemStack, inventoryStorage:InventoryStorage)->void:
	var item = itemStack.item;
	amountLabel.text = "%i/%i" % [itemStack.amount, item.maxStackAmount];
	nameLabel.text = item.fullName;
	item.SetDescription(description, itemStack);
	pass;

func _ready():
	pass;

func _process(delta):
	pass;
