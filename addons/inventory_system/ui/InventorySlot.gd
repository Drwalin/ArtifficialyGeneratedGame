extends ColorRect;
class_name InventorySlot;

@onready var icon:TextureRect = $Icon;
@onready var amountLabel:Label = $Label;

static var preloadedTooltip = preload("res://addons/inventory_system/ui/ItemTooltip.tscn");

var slotId:int = 0;
var inventoryUI:InventoryUI = null;
var inventoryStorage:InventoryStorage = null;
var itemStack:ItemStack = null;

func Init(inv:InventoryUI, slot:int)->void:
	slotId = slot;
	inventoryUI = inv;
	inventoryStorage = inventoryUI.inventoryStorage;
	itemStack = inventoryStorage.items[slotId];

func Close():
	inventoryStorage = null;
	itemStack = null;



func _get_tooltip(pos:Vector2)->String:
	if itemStack:
		return itemStack.item.fullName;
	return "";

func _make_custom_tooltip(for_text:String)->Object:
	if itemStack:
		if itemStack.item:
			var tooltip = preloadedTooltip.instantiate();
			tooltip.Set(itemStack, inventoryStorage);
			return tooltip;
	return null;




func _ready():
	pass;

func _process(delta):
	if inventoryUI:
		inventoryStorage = inventoryUI.inventoryStorage;
	if inventoryStorage:
		if inventoryStorage.items.size() > slotId:
			itemStack = inventoryStorage.items[slotId];
			if itemStack:
				if itemStack.item:
					icon.texture = itemStack.item.icon;
					amountLabel.text = "%d" % [itemStack.amount];
					return;
	inventoryStorage = null;
	itemStack = null;
	icon.texture = null;
	amountLabel.text = "";



# dragging data: InventorySlot

func _can_drop_data(pos:Vector2, data)->bool:
	if itemStack:
		return inventoryStorage.CanDropIn(data, self);
	return false;

func _drop_data(pos:Vector2, data):
	if itemStack:
		inventoryStorage.DropIn(data, self);

func _get_drag_data(pos:Vector2):
	if itemStack:
		if itemStack.item:
			var rect:TextureRect = TextureRect.new();
			rect.texture = icon.texture;
			set_drag_preview(rect);
			var data:InventoryDragData = InventoryDragData.new();
			data.amount = itemStack.amount;
			data.inventorySlot = self;
			data.itemStack = itemStack;
			return data;
	return null;

