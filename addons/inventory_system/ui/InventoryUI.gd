extends CanvasItem;
class_name InventoryUI;

var inventoryStorage:InventoryStorage;

func ConnectToStorage(storage:InventoryStorage)->void:
	inventoryStorage = storage;



func _process(delta):
	if visible:
		queue_redraw();
		if inventoryStorage == null:
			hide();
	else:
		inventoryStorage = null;


