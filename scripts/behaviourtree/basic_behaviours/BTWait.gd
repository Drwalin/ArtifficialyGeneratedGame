@tool
extends BTNode;
class_name BTWait;

@export var secondsToWait:float = 1;

func _init():
	print("Wait::_init");
	nodeName = "Wait";
	super._init();

func OnEnter(npc:CharacterBaseAI, data:Dictionary)->void:
	print("Wait::OnEnter");
	data["endTime"] = bt.GetTime() + secondsToWait;

func OnExit(npc:CharacterBaseAI, data:Dictionary)->void:
	print("Wait::OnExit");
	pass;

func Execute(npc:CharacterBaseAI, data:Dictionary)->void:
	print("Wait::Execute");
	if data["endTime"] <= bt.GetTime():
		Success();

func _ready()->void:
	print("Wait::_ready");
	super._ready();

func OrientObjects()->void:
	print("Wait::OrientObjects");
	var ms:int = secondsToWait*1000.0+0.5;
	if ms/60000 > 0:
		var s:int = (ms%60000)/1000;
		nodeName = "Wait %d:%d%d m:s" % [ms/60000, s/10, s%10]; 
	elif ms%1000 == 0:
		nodeName = "Wait %ds" %[int(secondsToWait)];
	else:
		nodeName = "Wait %.2fs" %[secondsToWait];
