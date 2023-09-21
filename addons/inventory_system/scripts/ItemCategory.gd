extends Resource;
class_name ItemCategory;

@export var name:String = "Default cateogry name";
@export var slotIcon:Texture2D = null;
@export var compatibleCategories:Array[ItemCategory] = [];

func IsCategoryCompatibleWithItem(item:Item)->bool:
	if item.categories.find(item):
		return true;
	for c in item.categories:
		if compatibleCategories.find(c):
			return true;
	return false;
