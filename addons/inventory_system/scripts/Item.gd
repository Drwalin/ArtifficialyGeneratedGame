extends Resource;
class_name Item;

@export var fullName:String;
@export var maxStackAmount:int = 1;
@export var categories:Array[ItemCategory] = [];
@export var mass:float = 1;
@export var icon:Texture2D;

static var time = Time;

func DropOnGround(inv:InventoryStorage, itemStack:ItemStack, pos:Vector3, amount:int)->void:
	
	pass;

func Tick(dt:float, inv:InventoryStorage, itemStack:ItemStack)->void:
	if itemStack.inUse != null:
		TickDuringUse(dt, inv, itemStack);
	else:
		TickOutsideUse(dt, inv, itemStack);

func BeginUse(inv:InventoryStorage, itemStack:ItemStack, target:Node3D)->void:
	if itemStack.inUse == false:
		itemStack.inUse = time.get_unix_time_from_system();
		OnUseBegin(inv, itemStack, target);

func EndUse(inv:InventoryStorage, itemStack:ItemStack, target:Node3D)->void:
	if itemStack.inUse:
		itemStack.inUse = null;
		OnUseEnd(inv, itemStack, target);


func SetDescription(description:Label, itemStack:ItemStack):
	description.text = "Default item description, something longer";


func TickDuringUse(dt:float, inv:InventoryStorage, itemStack:ItemStack)->void:
	pass;

func TickOutsideUse(dt:float, inv:InventoryStorage, itemStack:ItemStack)->void:
	pass;

func OnUseBegin(inv:InventoryStorage, itemStack:ItemStack, target:Node3D)->void:
	pass;

func OnUseEnd(inv:InventoryStorage, itemStack:ItemStack, target:Node3D)->void:
	pass;

func GetTooltip(inv:InventoryStorage, itemStack:ItemStack)->Object:
	return null;


