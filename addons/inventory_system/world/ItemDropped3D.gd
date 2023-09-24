@tool
extends Node3D;
class_name ItemDropped3D;

var inventoryStorage:InventoryStorage = null;

func Init(items:Array[ItemStack])->void:
	inventoryStorage = $InventoryStorage;
	inventoryStorage.slots.resize(items.size());
	for it in items:
		if it.item && it.amount > 0:
			var slot:ItemSlot = ItemSlot.new();
			slot.slotId = inventoryStorage.slots.size();
			slot.itemStack = ItemStack.new();
			slot.itemStack.Swap(it);
			inventoryStorage.slots.append(slot);
	SetMesh();

func _ready()->void:
	inventoryStorage = $InventoryStorage;
	if Engine.is_editor_hint():
		get_parent().set_editable_instance(self, true);
		$RigidBody3D.set_display_folded(true);
	SetMesh();

var __ddDDup:int = 0;
func _process(dt:float)->void:
	if Engine.is_editor_hint():
		__ddDDup += 1;
		if __ddDDup%60 == 1:
			SetMesh();

static var defaultCollisionShape:Shape3D = null;
func SetMesh()->void:
	inventoryStorage = $InventoryStorage;
	if inventoryStorage.slots.size() == 1:
		var item:Item = inventoryStorage.slots[0].itemStack.item;
		item.GenerateMeshes();
		$RigidBody3D/CollisionShape3D/MeshInstance3D.mesh = item.GetMesh3D();
		$RigidBody3D/CollisionShape3D.shape = item.GetShape3D();
		$RigidBody3D.inertia = item.GetInertia();
		$RigidBody3D.mass = item.GetMass();
	else:
		$RigidBody3D.mass = 10;
		$RigidBody3D.inertia = Vector3(0,0,0);
		$RigidBody3D/CollisionShape3D/MeshInstance3D.mesh = load("res://resources/models/LeatherSackOfItems.res");
		if defaultCollisionShape==null:
			var mesh:Mesh = $RigidBody3D/CollisionShape3D/MeshInstance3D.mesh;
			defaultCollisionShape = mesh.create_convex_shape(true, true);
		$RigidBody3D/CollisionShape3D.shape = defaultCollisionShape;
		#var r:RigidBody3D = $RigidBody3D;
		#$RigidBody3D.remove_child($RigidBody3D/CollisionShape3D);
		#$RigidBody3D.add_child(load("res://resources/models/LeatherSackOfItems.glb").instantiate());
	

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
