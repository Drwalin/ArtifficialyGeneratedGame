@tool
extends Node3D;
class_name ItemDropped3D;

@onready var inventoryStorage:InventoryStorage = $InventoryStorage;

func Init(items:Array[ItemStack])->void:
	inventoryStorage.slots.resize(items.size());
	for it in items:
		if it.item && it.amount > 0:
			var slot:ItemSlot = ItemSlot.new();
			slot.slotId = inventoryStorage.slots.size();
			slot.itemStack = ItemStack.new();
			slot.itemStack.Swap(it);
			inventoryStorage.slots.append(slot);

func _ready()->void:
	if Engine.is_editor_hint():
		get_parent().set_editable_instance(self, true);
		$RigidBody3D.set_display_folded(true);
		print("123'");
#		if $InventoryStorage.slots.size() == 1:
#			$RigidBody3D/CollisionShape3D/MeshInstance3D.mesh = $InventoryStorage.slots[0].itemStack.item.GetMesh3D();
#			$RigidBody3D/CollisionShape3D.shape = $InventoryStorage.slots[0].itemStack.item.GetShape3D();
#		else:
#			$RigidBody3D.remove_child($RigidBody3D/CollisionShape3D);
#			$RigidBody3D.add_child(load("res://resources/models/LeatherSackOfItems.glb").instantiate());
	#else:
	if inventoryStorage.slots.size() == 1:
		$RigidBody3D/CollisionShape3D/MeshInstance3D.mesh = inventoryStorage.slots[0].itemStack.item.GetMesh3D();
		$RigidBody3D/CollisionShape3D.shape = inventoryStorage.slots[0].itemStack.item.GetShape3D();
	else:
		$RigidBody3D.remove_child($RigidBody3D/CollisionShape3D);
		$RigidBody3D.add_child(load("res://resources/models/LeatherSackOfItems.glb").instantiate());

static func CreateDroppedItems(items:Array[ItemStack], pos:Vector3, node:Node)->ItemDropped3D:
	if items.size() > 0:
		if items[0].amount > 0 && items[0].item:
			var dropped:ItemDropped3D = ItemDropped3D.new();
			dropped.add_child(dropped);
			dropped.Init(items);
			dropped.position = pos;
			return dropped;
	return null;

func OnUse(instigator:CharacterBaseController)->void:
	var dstStorage:InventoryStorage = instigator.inventoryStorage;
	for slot in inventoryStorage.slots:
		if slot.itemStack.amount > 0 && slot.itemStack.item:
			var dragData:ItemDragData = ItemDragData.new(slot.itemStack, slot.itemStack.amount, slot, inventoryStorage, false);
			dstStorage.DropIn(dragData, null);
