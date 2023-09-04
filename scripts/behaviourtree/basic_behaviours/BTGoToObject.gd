@tool
extends BTNode;
class_name BTGoToObject;

@export var distanceTolerance:float = 1.0;
@export var blackboardFieldNameWithTargetPointer:String = "target_object";
@export var retryTime:float = 0.0;
@export var retryTimes:int = 0;

func _init()->void:
	nodeName = "Go to object";
	super._init();

func OnEnter()->void:
	var target:Node3D = bb().data[blackboardFieldNameWithTargetPointer];
	if target:
		var npc:CharacterBaseAI = bb().npc;
		npc.navigationAgent.set_target_position(target.global_position);
		bb().nodesStack.back()[1]["lastTargetPosition"] = target.global_position;

func OnExit()->void:
	pass;

func Execute()->void:
	var npc = bb().npc as CharacterBaseAI;
	#var target:Node3D = bb().data[blackboardFieldNameWithTargetPointer];
	if npc.navigationAgent.is_navigation_finished():
		Success();
		return;
	var target:Node3D = bb().data[blackboardFieldNameWithTargetPointer];
	if target:
		if (target.global_position - bb().nodesStack.back()[1]["lastTargetPosition"]).length() > 1:
			npc.navigationAgent.set_target_position(target.global_position);
			bb().nodesStack.back()[1]["lastTargetPosition"] = target.global_position;
	#else: # do retries:
	#	npc.navigationAgent.set_target_position(npc.global_position);
	#	Fail();
