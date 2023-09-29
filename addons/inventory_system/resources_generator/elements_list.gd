extends HBoxContainer;

@export var elementEditorScene:Resource = null;
@export var elementName:String = "Item";
@export var elementManager:Script;

@onready var elementsList = $VBoxContainer/HBoxContainer/ScrollContainer/VBoxContainer;

func _ready():
	name = elementName;
	#PreloadElements();
	UpdateList();

func _process(delta):
	pass;

func GetElementsList()->Array:
	return [];

func CreateNewElement()->void:
	pass;
	UpdateList();

func UpdateList()->void:
	pass;

func DeleteSelected()->void:
	var toDelete=[];
	for e in elementsList.get_children():
		var checkbox:CheckBox = e.find_child("CheckBox") as CheckBox;
		if checkbox:
			if checkbox.button_pressed:
				toDelete.append(e.find_child("Name"));
	UpdateList();

func DeleteElement(element)->void:
	pass;
