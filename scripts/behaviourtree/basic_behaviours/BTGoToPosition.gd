@tool
extends BTNode;
class_name BTGoToPosition;

@export var distanceTolerance:float = 1.0;

func _init()->void:
	nodeName = "Go to position";

func _ready() -> void:
	pass # Replace with function body.

func OnEnter()->void:
	var pos:Vector3 = bb().data.target_position;
	if pos:
		bb().npc

func OnExit()->void:
	pass;

func Execute()->void:
	#if bb().stack.back().endTime <= internalTime:
		Success();

func _process(delta: float) -> void:
	pass
