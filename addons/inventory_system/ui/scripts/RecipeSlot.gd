extends HBoxContainer;
class_name RecipeSlot;

var recipe:ItemRecipe = null;
var craftableAmount:int = 0;

var listOfRecipes:ListOfRecipes;
@onready var craftingStation:CraftingStationBase = listOfRecipes.craftingStation;
@onready var ingredients:HBoxContainer = $Ingredients;
@onready var products:HBoxContainer = $Products
@onready var labelCountCraft:Label = $LabelCountCraft;

@onready var preloadedItemSlot = load("res://addons/inventory_system/ui/scenes/ItemSlotInRecipe.tscn");

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
	craftableAmount = recipe.CanBeCraftedFrom(craftingStation.storage, craftingStation.storage.get_parent());
	labelCountCraft.text = "%d" % [craftableAmount];





var MouseOver = false
func _on_Area2D_mouse_entered():
	MouseOver = true
func _on_Area2D_mouse_exited():
	MouseOver = false
	
func _input(event):
	if event is InputEventMouseButton:
		if MouseOver == true:
			craftingStation.ClickRecipe(self);
