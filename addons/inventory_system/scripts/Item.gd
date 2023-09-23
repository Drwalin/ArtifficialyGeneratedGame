extends Resource;
class_name Item;

@export var fullName:String;
@export var maxStackAmount:int = 1;
@export var categories:Array[ItemCategory] = [];
@export var mass:float = 1;
@export var icon:Texture2D;
@export var shape3D:Shape3D;
@export var mesh3D:Mesh;

func GetMesh3D()->Mesh:
	if mesh3D==null:
		mesh3D = ItemMeshUtil.GenerateDropMeshForItem(self);
		if resource_path != "":
			ResourceSaver.save(self, resource_path);
			ResourceSaver.save(mesh3D, resource_path.replace(".tres", ".mesh.res"));
	return mesh3D;

func GetShape3D()->Shape3D:
	if shape3D==null:
		shape3D = ItemMeshUtil.GenerateDropShapeForItem(self);
		if resource_path != "":
			ResourceSaver.save(self, resource_path);
			ResourceSaver.save(shape3D, resource_path.replace(".tres", ".shape.res"));
	return shape3D;

func DropOnGround(inv:InventoryStorage, itemStack:ItemStack, pos:Vector3, amount:int)->void:
	pass;

func Tick(dt:float, inv:InventoryStorage, itemStack:ItemStack)->void:
	if itemStack.inUseSince != null:
		TickDuringUse(dt, inv, itemStack);
	else:
		TickOutsideUse(dt, inv, itemStack);

func BeginUse(inv:InventoryStorage, itemStack:ItemStack, target:Node3D)->void:
	if itemStack.inUseSince == false:
		itemStack.inUseSince = Time.get_unix_time_from_system();
		OnUseBegin(inv, itemStack, target);

func EndUse(itemStack:ItemStack)->void:
	if itemStack.inUseSince:
		itemStack.inUseSince = null;
		OnUseEnd(itemStack);


func SetDescription(description:Label, itemStack:ItemStack):
	description.text = "Default item description, something longer";


func TickDuringUse(dt:float, inv:InventoryStorage, itemStack:ItemStack)->void:
	pass;

func TickOutsideUse(dt:float, inv:InventoryStorage, itemStack:ItemStack)->void:
	pass;

func OnUseBegin(inv:InventoryStorage, itemStack:ItemStack, target:Node3D)->void:
	pass;

func OnUseEnd(itemStack:ItemStack)->void:
	pass;

func GetTooltip(inv:InventoryStorage, itemStack:ItemStack)->Object:
	return null;


