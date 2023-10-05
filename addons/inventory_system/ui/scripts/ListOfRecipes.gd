extends VBoxContainer;
class_name ListOfRecipes;

@onready var craftingStation:CraftingStationBase = get_parent();
@onready var filterNode:LineEdit = $HBoxContainer/LineEdit;
@onready var recipeList:VBoxContainer = $ScrollContainer/VBoxContainer;
var filterText:String = "";

func _ready()->void:
	var recipeSlotTemplate = load("res://addons/inventory_system/ui/scenes/RecipeSlot.tscn");
	for recipe in craftingStation.recipeDatabase.recipes:
		var slot:RecipeSlot = recipeSlotTemplate.instantiate();
		slot.listOfRecipes = self;
		slot.recipe = recipe;
		recipeList.add_child(slot);
	pass;

func _process(dt:float)->void:
	filterNode = $HBoxContainer/LineEdit
	filterText = filterNode.text;
