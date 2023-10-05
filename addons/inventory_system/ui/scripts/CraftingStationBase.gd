extends BoxContainer;
class_name CraftingStationBase;

var storage:InventoryStorage;

@export var recipeDatabase:ItemRecipeDatabase;

var selectedSlot:RecipeSlot;

func _ready():
	$CraftingSide/Button.pressed.connect(self.CraftPressed);

func CraftPressed()->void:
	if selectedSlot:
		var value:int = $CraftingSide/HSlider.value;
		if value > 0:
			selectedSlot.recipe.TryCrafting(storage, storage, storage.get_parent(), value);





func _process(delta):
	$CraftingSide.position.x = $ListOfRecipes.size.x;
	$CraftingSide.size.y = $ListOfRecipes.size.y;
	$ColorRect.size = $ListOfRecipes.size + Vector2($CraftingSide.size.x, 0);
	if selectedSlot:
		var craftableAmount = selectedSlot.craftableAmount;
		if craftableAmount > 0:
			$CraftingSide/HSlider.max_value = craftableAmount;
			if $CraftingSide/Button.disabled:
				$CraftingSide/HSlider.editable = true;
				$CraftingSide/HSlider.min_value = 1;
				$CraftingSide/Button.disabled = false;
		elif $CraftingSide/Button.disabled == false:
			$CraftingSide/HSlider.editable = false;
			$CraftingSide/HSlider.max_value = 0;
			$CraftingSide/HSlider.min_value = 0;
			$CraftingSide/HSlider.value = 0;
			$CraftingSide/Button.disabled = true;
		$CraftingSide/Label.text = "%d" % [$CraftingSide/HSlider.value];

func SelectRecipeSlot(recipeSlot:RecipeSlot)->void:
	selectedSlot = recipeSlot;
	var children = $CraftingSide/HBoxContainer.get_children();#.duplicate();
	for child in children:
		$CraftingSide/HBoxContainer.remove_child(child);
	var newSlot = load("res://addons/inventory_system/ui/scenes/RecipeSlot.tscn").instantiate();
	newSlot.listOfRecipes = recipeSlot.listOfRecipes;
	newSlot.recipe = recipeSlot.recipe;
	$CraftingSide/HBoxContainer.add_child(newSlot);
