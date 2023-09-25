@tool
extends RigidBody3D;
class_name ItemDropped3D;

@onready var inventoryStorage:InventoryStorage = $InventoryStorage;

func Init(items:Array[ItemStack])->void:
	inventoryStorage = $InventoryStorage;
	inventoryStorage.slots = [];
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
		$CollisionShape3D.set_display_folded(true);
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
		$CollisionShape3D/MeshInstance3D.mesh = item.GetMesh3D();
		$CollisionShape3D.shape = item.GetShape3D();
		inertia = item.GetInertia();
		mass = item.GetMass();
	else:
		mass = 1;
		inertia = Vector3(0,0,0);
		$CollisionShape3D/MeshInstance3D.mesh = load("res://resources/models/LeatherSackOfItems.res");
		if defaultCollisionShape==null:
			var mesh:Mesh = $CollisionShape3D/MeshInstance3D.mesh;
			defaultCollisionShape = mesh.create_convex_shape(true, true);
		$CollisionShape3D.shape = defaultCollisionShape;
	

static func CreateDroppedItems(items:Array[ItemStack], pos:Vector3, node:Node)->ItemDropped3D:
	if items.size() > 0:
		if items[0].amount > 0 && items[0].item:
			var dropped:ItemDropped3D = ItemDropped3D.new();
			dropped.add_child(dropped);
			dropped.Init(items);
			dropped.position = pos;
			return dropped;
	return null;

func OnUseByCharacter(instigator:CharacterBaseController)->void:
	var dstStorage:InventoryStorage = instigator.inventoryStorage;
	var anyLeft:bool = false;
	for slot in inventoryStorage.slots:
		if slot.itemStack.amount > 0 && slot.itemStack.item:
			var dragData:ItemDragData = ItemDragData.new(slot.itemStack, slot.itemStack.amount, slot, inventoryStorage, false);
			dstStorage.DropIn(dragData, null);
			if slot.itemStack.amount > 0:
				anyLeft = true;
	if anyLeft==false:
		self.queue_free();
