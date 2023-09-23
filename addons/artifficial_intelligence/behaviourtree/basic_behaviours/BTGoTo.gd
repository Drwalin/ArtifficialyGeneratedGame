@tool
extends BTNode;
class_name BTGoTo;

@export var distanceTolerance:float = 1.0;
@export var blackboardFieldNameWithTargetPointer:String = "target_object";
@export var retryTime:float = 0.0;
@export var retryTimes:int = 0;

func _init()->void:
	PrintDebug.Print("GoTo::_init");
	nodeName = "Go to";
	super._init();

func OnEnter(npc:CharacterBaseAI, data:Dictionary)->void:
	PrintDebug.Print("GoTo::OnEnter");
	bb().npc.navigationAgent.call_deferred("set_path_max_distance", distanceTolerance);
	var target:Node3D = bb().data[blackboardFieldNameWithTargetPointer];
	if target:
		npc.navigationAgent.call_deferred("set_target_position", target.global_position);
		data["lastTargetPosition"] = target.global_position;
	else:
		npc.navigationAgent.call_deferred("set_target_position", npc.global_position);
		data["lastTargetPosition"] = npc.global_position;

func OnExit(npc:CharacterBaseAI, data:Dictionary)->void:
	PrintDebug.Print("GoTo::OnExit");
	pass;

func Execute(npc:CharacterBaseAI, data:Dictionary)->void:
	PrintDebug.Print("GoTo::Execute");
	var target:Node3D = bb().data[blackboardFieldNameWithTargetPointer];
	if npc.isNavigationFinished:
		Success();
		return;
	if target:
		if (target.global_position - data["lastTargetPosition"]).length() > 1:
			npc.navigationAgent.call_deferred("set_target_position", target.global_position);
			data["lastTargetPosition"] = target.global_position;
