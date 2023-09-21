extends Resource;
class_name ItemStack;

@export var item:Item = null;
@export var amount:int = 0;
@export var tag:Dictionary = {};
var inUseSince = null;

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

func EndUse(inv:InventoryStorage, target:Node3D)->void:
	if item:
		item.EndUse(inv, self, target);

func SetDescription(description:Label):
	if item:
		item.etDescription(description, self);

