@tool
extends BTNode;
class_name BTGoTo;

@export var distanceTolerance:float = 1.0;
@export var blackboardFieldNameWithTargetPointer:String = "target_object";
@export var retryTime:float = 0.0;
@export var retryTimes:int = 0;

func _init()->void:
	nodeName = "Go to";
	super._init();

func OnEnter(npc:CharacterBaseAI, data:Dictionary)->void:
	bb().npc.navigationAgent.set_path_max_distance(distanceTolerance);
	var target:Node3D = bb().data[blackboardFieldNameWithTargetPointer];
	if target:
		npc.navigationAgent.set_target_position(target.global_position);
		data["lastTargetPosition"] = target.global_position;
	else:
		npc.navigationAgent.set_target_position(npc.global_position);
		data["lastTargetPosition"] = npc.global_position;

func OnExit(npc:CharacterBaseAI, data:Dictionary)->void:
	pass;

func Execute(npc:CharacterBaseAI, data:Dictionary)->void:
	var target:Node3D = bb().data[blackboardFieldNameWithTargetPointer];
	if npc.navigationAgent.is_navigation_finished() || npc.navigationAgent.is_target_reached():
		if target:
			data["lastTargetPosition"] = npc.global_position;
		if npc.name == "CharacterBody3D2":
			print("Goto success");
		Success();
		return;
	if target:
		if (target.global_position - data["lastTargetPosition"]).length() > 1:
			npc.navigationAgent.set_target_position(target.global_position);
			data["lastTargetPosition"] = target.global_position;
	#else: # do retries:
	#	npc.navigationAgent.set_target_position(npc.global_position);
	#	Fail();
