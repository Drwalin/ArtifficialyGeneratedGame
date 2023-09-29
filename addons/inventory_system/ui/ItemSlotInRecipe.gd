extends ColorRect;
class_name ItemSlotInRecipe;

var itemStack:ItemStack = null;
var isIngredient:bool = false;
@onready var craftingStation:CraftingStationBase = get_parent().get_parent().craftingStation;
@onready var label:Label = $Label;
@onready var icon:TextureRect = $Icon;
@onready var grayOut:ColorRect = $ColorRect3;

func SetItem(stack:ItemStack)->void:
	itemStack = stack;

func SetIsIngredient(value:bool)->void:
	isIngredient = value;

func _ready()->void:
	if !isIngredient:
		self.set_process(false);
		label.text = "0/%d" % [itemStack.amount];
		grayOut.visible = true;
	else:
		label.text = "%d" % [itemStack.amount];
	icon.texture = itemStack.item.icon;

func _process(dt:float)->void:
	if isIngredient:
		var storage:InventoryStorage = craftingStation.inventoryStorage;
		if storage:
			var amount:int = storage.CountItems(itemStack);
			label.text = "%d/%d" % [amount, itemStack.amount];
			grayOut.visible = (amount < itemStack.amount);
			
