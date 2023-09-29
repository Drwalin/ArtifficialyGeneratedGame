extends HBoxContainer;
class_name RecipeSlot;

var recipe:ItemRecipe = null;

@onready var craftingStation:CraftingStationBase = get_parent().get_parent().get_parent().get_parent().craftingStation;
@onready var ingredients:HBoxContainer = $Ingredients;
@onready var products:HBoxContainer = $Products

static var preloadedItemSlot = load("res://addons/inventory_system/ui/ItemSlotInRecipe.tscn");

func _ready()->void:
	for item in recipe.requiredItems:
		var ingr:ItemSlotInRecipe = preloadedItemSlot.instantiate();
		ingr.SetItem(item);
		ingr.SetIsIngredient(true);
		ingredients.add_child(ingr);
	for item in recipe.result:
		var prod:ItemSlotInRecipe = preloadedItemSlot.instantiate();
		prod.SetItem(item);
		prod.SetIsIngredient(false);
		products.add_child(prod);

func IsShown()->bool:
	# @TODO: implement filtering
	return true;

func _gui_input(event)->void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			craftingStation.SelectRecipeSlot(self);

func _process(dt:float)->void:
	if IsShown():
		if !visible:
			visible = true;
	elif visible:
		visible = false;
