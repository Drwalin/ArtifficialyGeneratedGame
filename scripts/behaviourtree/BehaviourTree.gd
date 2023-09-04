extends Node;
class_name BehaviourTree;

var rootNode : BTNode;
var bb : BTBlackboard;
var dt : float = 0.0166666;

var blackboards : Dictionary = {};

func _ExitCurrentNode(enableImmediateExecutionIfNeeded:bool)->void:
	bb._ExitCurrentNode(enableImmediateExecutionIfNeeded);

func _EnterNode(node:BTNode)->void:
	bb._EnterNode(node);

func RestartBT()->void:
	bb.RestartBT();

func _enter_tree()->void:
	for c in get_children():
		if c is BTNode:
			rootNode = c;

func _exit_tree()->void:
	var bbs = blackboards.keys().duplicate(false);
	for bs in bbs:
		bs.SetBehaviourTree(null);

func _process(delta: float)->void:
	dt = delta;
	for b in blackboards.keys():
		bb = b;
		bb.Process(delta);
	bb = null;

