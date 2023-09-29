extends Control;
class_name ListOfRecipes;

@onready var craftingStation:CraftingStationBase = get_parent();
@onready var filterNode:LineEdit = $VBoxContainer/HBoxContainer/LineEdit;
var filterText:String = "";

func _ready()->void:
	pass;

func _process(dt:float)->void:
	filterText = filterNode.text;
