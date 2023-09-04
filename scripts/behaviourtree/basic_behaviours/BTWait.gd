@tool
extends BTNode;
class_name BTWait;

@export var secondsToWait:float = 1;

func _init():
	super();
	nodeName = "Wait";

func OnEnter()->void:
	bb().stack.back().endTime = bt.GetTime() + secondsToWait;

func OnExit()->void:
	pass;

func Execute()->void:
	if bb().stack.back().endTime <= bt.GetTime():
		Success();
