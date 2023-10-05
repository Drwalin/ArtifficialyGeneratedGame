extends ColorRect;
class_name ItemSlotInRecipe;

var itemStack:ItemStack = null;
var isIngredient:bool = false;
@onready var recipeSlot:RecipeSlot = get_parent().get_parent();
@onready var craftingStation:CraftingStationBase = recipeSlot.craftingStation;
@onready var label:Label = $Label;
@onready var icon:TextureRect = $Icon;
@onready var grayOut:ColorRect = $ColorRect3;

func SetItem(stack:ItemStack)->void:
	itemStack = stack;

func SetIsIngredient(value:bool)->void:
	isIngredient = value;

func _ready()->void:
	if isIngredient:
		label.text = "0/%d" % [itemStack.amount];
		grayOut.visible = true;
	else:
		label.text = "%d" % [itemStack.amount];
	icon.texture = itemStack.item.icon;

func _process(dt:float)->void:
	if isIngredient:
		var storage:InventoryStorage = craftingStation.storage;
		if storage:
			var amount:int = storage.CountItems(itemStack);
			label.text = "%d/%d" % [amount, itemStack.amount];
			grayOut.visible = (amount < itemStack.amount);
	else:
		if recipeSlot.craftableAmount > 0:
			grayOut.visible = false;
		else:
			grayOut.visible = true;





func _get_tooltip(pos:Vector2)->String:
	if itemStack:
		if itemStack.item:
			return itemStack.item.fullName;
	return "";

func _make_custom_tooltip(for_text:String)->Object:
	if itemStack:
		if itemStack.item && itemStack.amount > 0:
			var tooltip = load("res://addons/inventory_system/ui/scenes/ItemTooltip.tscn").instantiate();
			tooltip.set_script(load("res://addons/inventory_system/ui/scripts/ItemTooltip.gd"));
			tooltip.Set(itemStack, null);
			return tooltip;
	return null;
