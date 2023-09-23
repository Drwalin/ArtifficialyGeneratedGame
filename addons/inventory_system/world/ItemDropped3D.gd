extends Node3D;
class_name ItemDropped3D;

@export var inventoryStorage:InventoryStorage
@export var items:Array[ItemStack] = [];
var sss:Dictionary;

func _init(_items:Array[ItemStack], pos:Vector3)->void:
	items.resize(_items.size());
	for i in range(0, items.size()):
		var src:ItemStack = _items[i].duplicate();
		var dst:ItemStack = ItemStack.new();
		dst.amount = src.amount;
		dst.item = src.item;
		dst.tag = src.tag.duplicate();
		items[i] = dst;
		src.item = null;
		src.amount = 0;
		src.tag = {};

static func CreateDroppedItems(items:Array[ItemStack], pos:Vector3, node:Node)->ItemDropped3D:
	var dropped:ItemDropped3D = ItemDropped3D.new(items, pos);
	dropped.add_child(dropped);
	return dropped;

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func OnUse(instigator:CharacterBaseController)->void:
	#instigator.inventoryStorage.
	pass;
