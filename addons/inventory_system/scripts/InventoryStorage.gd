extends Node
class_name InventoryStorage;

@export var items:Array[ItemStack];
@export var expandableInventory:bool = false;
@export var infiniteStacks:bool = false;

func _ready():
	pass;

func _process(delta:float):
	pass;

func Sort()->void:
	pass;


func CanDropIn(data, inventorySlot:InventorySlot)->bool:
	return false;

func DropIn(data, inventorySlot:InventorySlot)->void:
	pass;
