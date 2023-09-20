extends ColorRect;
class_name InventorySlot;

@onready var icon:TextureRect = $Icon;
@onready var amountLabel:Label = $Label;

static var preloadedTooltip = preload("res://addons/inventory_system/ui/ItemTooltip.tscn");

var slotId:int = 0;
var inventoryUI:InventoryUI = null;
var inventoryStorage:InventoryStorage = null;

func GetItemStack()->ItemStack:
	if inventoryStorage:
		if slotId < inventoryStorage.items.size():
			var _is = inventoryStorage.items[slotId];
			if _is:
				return _is;
			inventoryStorage.items[slotId] = ItemStack.new();
			return inventoryStorage.items[slotId];
	return null;

func Init(inv:InventoryUI, slot:int)->void:
	slotId = slot;
	inventoryUI = inv;
	inventoryStorage = inventoryUI.storage;

func Close():
	inventoryStorage = null;




func _get_tooltip(pos:Vector2)->String:
	var itemStack:ItemStack = GetItemStack();
	if itemStack:
		return itemStack.item.fullName;
	return "";

func _make_custom_tooltip(for_text:String)->Object:
	var itemStack:ItemStack = GetItemStack();
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
		inventoryStorage = inventoryUI.storage;
	if inventoryStorage:
		if inventoryStorage.items.size() > slotId:
			var itemStack:ItemStack = GetItemStack();
			if itemStack:
				if itemStack.item:
					icon.texture = itemStack.item.icon;
					amountLabel.text = "%d" % [itemStack.amount];
					return;
	icon.texture = null;
	amountLabel.text = "";



# dragging data: InventorySlot

func _can_drop_data(pos:Vector2, data)->bool:
	if GetItemStack():
		return inventoryStorage.CanDropIn(data, self);
	return false;

func _drop_data(pos:Vector2, data):
	if GetItemStack():
		inventoryStorage.DropIn(data, self);

func _get_drag_data(pos:Vector2):
	var itemStack:ItemStack = GetItemStack();
	if itemStack:
		if itemStack.item:
			var rect:TextureRect = TextureRect.new();
			rect.texture = icon.texture;
			set_drag_preview(rect);
			var data:InventoryDragData = InventoryDragData.new();
			data.amount = itemStack.amount;
			data.inventorySlot = self;
			return data;
	return null;

