extends Resource;
class_name ItemStack;

@export var item:Item = null;
@export var amount:int = 0;
@export var tag:Dictionary;
var inUseSince = null;

func GetItemUsageTime():
	if inUseSince != null:
		return Item.time.get_unix_time_from_system() - inUseSince;
	return null;

func IsInUse()->bool:
	return inUseSince != null;

