extends ColorRect;
class_name InventorySlot;

@onready var icon:TextureRect = $Icon;
@onready var amountLabel:Label = $Label;

@export var slotId:int = 0;
var inventoryUI:InventoryUI = null;
func GetStorage()->InventoryStorage:
	if inventoryUI:
		return inventoryUI.storage;
	return null;

func GetItemSlot()->ItemSlot:
	if GetStorage():
		if slotId < GetStorage().slots.size():
			var _is = GetStorage().slots[slotId];
			if _is:
				return _is;
	return null;

func GetItemStack()->ItemStack:
	var slot = GetItemSlot();
	if slot:
		if slot.itemStack == null:
			slot.itemStack = ItemStack.new();
		return slot.itemStack;
	return null;

func SetInventoryUI(inv:InventoryUI)->void:
	inventoryUI = inv;



func _get_tooltip(pos:Vector2)->String:
	var itemStack:ItemStack = GetItemStack();
	if itemStack:
		if itemStack.item:
			return itemStack.item.fullName;
	return "";

func _make_custom_tooltip(for_text:String)->Object:
	var itemStack:ItemStack = GetItemStack();
	if itemStack:
		if itemStack.item && itemStack.amount > 0:
			var tooltip = load("res://addons/inventory_system/ui/ItemTooltip.tscn").instantiate();
			tooltip.set_script(load("res://addons/inventory_system/ui/ItemTooltip.gd"));
			tooltip.Set(itemStack, GetStorage());
			return tooltip;
	return null;




func _ready():
	pass;

func _process(delta):
	if GetStorage():
		if GetStorage().slots.size() > slotId:
			var itemStack:ItemStack = GetItemStack();
			if itemStack:
				if itemStack.item:
					icon.texture = itemStack.item.icon;
					if itemStack.amount == 1:
						amountLabel.text = "";
					else:
						amountLabel.text = "%d" % [itemStack.amount];
					return;
	icon.texture = null;
	amountLabel.text = "";



# dragging data: InventorySlot

func _can_drop_data(pos:Vector2, data)->bool:
	if data is ItemDragData:
		if GetItemStack():
			return GetStorage().CanDropIn(data, GetItemSlot());
	return false;

func _drop_data(pos:Vector2, data):
	if data is ItemDragData:
		if GetItemStack():
			GetStorage().DropIn(data, GetItemSlot());

func _get_drag_data(pos:Vector2):
	var itemStack:ItemStack = GetItemStack();
	if itemStack:
		if itemStack.item && itemStack.amount > 0:
			return InitiateDragging(itemStack);
	return null;

func InitiateDragging(itemStack:ItemStack):
	# check for dragging mode:
	#@TODO: impement shift-click to quickly drop to another inventory
	# !!! right button dragging does not work !!! - right drag -> (at least)half stack drag
	# left drag -> full stack drag
	# left drag+ctrl -> (at least)half stack drag
	
	var rect:TextureRect = TextureRect.new();
	rect.texture = icon.texture;
	rect.expand_mode = TextureRect.EXPAND_FIT_WIDTH | TextureRect.EXPAND_FIT_HEIGHT;
	rect.z_index = 0xFF;
	set_drag_preview(rect);
	rect.size = Vector2(48, 48);
	
	var amount:int = itemStack.amount;
	if Input.is_action_pressed("inventory_system_dragging_half_stack"):
		amount = (amount+1)>>1;
	return ItemDragData.new(GetItemSlot(), GetStorage(), amount);
	

