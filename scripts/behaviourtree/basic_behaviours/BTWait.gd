@tool
extends BTNode;
class_name BTWait;

@export var secondsToWait:float = 1;

func _init():
	nodeName = "Wait";
	super._init();

func OnEnter()->void:
	bb().nodesStack.back()[1]["endTime"] = bt.GetTime() + secondsToWait;

func OnExit()->void:
	pass;

func Execute()->void:
	if bb().nodesStack.back()[1]["endTime"] <= bt.GetTime():
		Success();

func _ready()->void:
	super._ready();

func OrientObjects()->void:
	pass;
