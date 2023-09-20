extends Control;

@onready var colorRect1 = $Color1;
@onready var colorRect2 = $Color2;
@onready var nameLabel = $Container/Title/Name;
@onready var amountLabel = $Container/Title/Amount;
@onready var description = $Container/Description;

func Set(itemStack:ItemStack, inventoryStorage:InventoryStorage)->void:
	colorRect1 = $Color1;
	colorRect2 = $Color2;
	nameLabel = $Container/Title/Name;
	amountLabel = $Container/Title/Amount;
	description = $Container/Description;
	var item = itemStack.item;
	amountLabel.text = "%i/%i" % [itemStack.amount, item.maxStackAmount];
	nameLabel.text = item.fullName;
	item.SetDescription(description, itemStack);
	pass;

func _ready():
	colorRect1 = $Color1;
	colorRect2 = $Color2;
	nameLabel = $Container/Title/Name;
	amountLabel = $Container/Title/Amount;
	description = $Container/Description;

func _process(delta):
	pass;
