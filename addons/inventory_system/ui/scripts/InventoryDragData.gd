extends Object;
class_name InventoryDragData;

var inventorySlot:InventorySlot;
var amount:int;

func GetItemStack()->ItemStack:
	return inventorySlot.GetItemStack();

func GetStorage()->InventoryStorage:
	return inventorySlot.inventoryStorage;

