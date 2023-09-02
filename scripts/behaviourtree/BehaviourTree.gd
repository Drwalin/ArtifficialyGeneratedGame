extends Node;
class_name BehaviourTree;

var rootNode : BTSequence;
var bb : BTBlackboard;
var dt : float = 0.0166666;

var blackboards : Dictionary = {};

func _init()->void:
	rootNode = BTSequence.new();
	rootNode.bt = self;
	add_child(rootNode);

func _ExitCurrentNode(enableImmediateExecutionIfNeeded:bool)->void:
	bb._ExitCurrentNode(enableImmediateExecutionIfNeeded);

func _EnterNode(node:BTNode)->void:
	bb._EnterNode(node);

func RestartBT()->void:
	bb.RestartBT();

func _exit_tree()->void:
	var bbs = blackboards.keys().duplicate(false);
	for bs in bbs:
		bs.SetBehaviourTree(null);
	rootNode.Destroy();
	rootNode.free();
	rootNode = null;

func _process(delta: float)->void:
	dt = delta;
	for b in blackboards.keys():
		bb = b;
		bb.Process(delta);
	bb = null;

