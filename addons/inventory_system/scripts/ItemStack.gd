extends Resource;
class_name ItemStack;

@export var item:Item = null;
@export var amount:int = 0;
@export var tag:Dictionary = {};
@export var inUseSince:float = -1;	# negative value means that is not in use currently

func IsEmpty()->bool:
	return item==null || amount <= 0;

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

func TransferTo(other:ItemStack, count:int, ignoreCapacity:bool)->int:
	if IsSame(other) || other.IsEmpty():
		if !IsEmpty():
			count = min(count, amount);
			if !ignoreCapacity:
				count = min(count, item.maxStackAmount-(other.amount if !other.IsEmpty() else 0));
			if count > 0:
				if other.IsEmpty():
					other.item = item;
				other.AddAmount(count);
				AddAmount(-count);
	return 0;

func GetItemUsageTime():
	if inUseSince >= 0:
		return Time.get_unix_time_from_system() - inUseSince;
	return null;

func IsInUse()->bool:
	return inUseSince >= 0;

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
		inUseSince = -1;

func SetDescription(description:Label):
	if item:
		item.SetDescription(description, self);

