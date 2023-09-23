extends Resource;
class_name ItemStack;

@export var item:Item = null;
@export var amount:int = 0;
@export var tag:Dictionary = {};
var inUseSince = null;

func IsSame(other:ItemStack)->bool:
	return item == other.item && tag == other.tag;

func Swap(other:ItemStack)->void:
	var tmpI:Item = item;
	item = other.item;
	other.item = tmpI;
	
	var tmpA:int = amount;
	amount = other.amount;
	other.amount = tmpA;
	
	var tmpT:Dictionary = tag;
	tag = other.tag;
	other.tag = tmpT;
	
	EndUse();
	other.EndUse();

func AddAmount(delta:int)->void:
	if amount + delta <= 0:
		EndUse();
		amount = 0;
		item = null;
		tag = {};
	else:
		amount += delta;
		

func GetItemUsageTime():
	if inUseSince != null:
		return Time.get_unix_time_from_system() - inUseSince;
	return null;

func IsInUse()->bool:
	return inUseSince != null;

func Tick(dt:float, inv:InventoryStorage)->void:
	if item:
		item.Tick(dt, inv, self);

func BeginUse(inv:InventoryStorage, target:Node3D)->void:
	if item:
		item.BeginUse(inv, self, target);
		inUseSince = Time.get_unix_time_from_system();

func EndUse()->void:
	if item:
		item.EndUse(self);
		inUseSince = null;

func SetDescription(description:Label):
	if item:
		item.SetDescription(description, self);

