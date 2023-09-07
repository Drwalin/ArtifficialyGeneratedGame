extends Node;
class_name BTBlackboard;

var bt : BehaviourTree
var npc : CharacterBaseAI;
var nodesStack : Array = []; # [[node, {local_variables}]]
var dt : float;
var data = {};

enum BTNodeFinishState {
	FAILURE,
	SUCCESS,
};

var previousNodeFinishState : int = BTNodeFinishState.SUCCESS;

func _ready()->void:
	print("Blackboard::_ready");
	npc = get_parent();
	SetBehaviourTree(npc.behaviourTree);

func SetBehaviourTree(_bt: BehaviourTree)->void:
	print("Blackboard::SetBehaviourTree");
	if bt:
		RestartBT();
		bt.blackboards.erase(self);
	bt = _bt;
	if bt:
		bt.blackboards[self] = self;

func _ExitCurrentNode(enableImmediateExecutionIfNeeded:bool=false)->void:
	print("Blackboard::_ExitCurrentNode");
	if nodesStack.size() > 0:
		var node:BTNode = nodesStack.back()[0];
#		if npc.name == "CharacterBody3D2":
#			print("Leaving: ", node.name, " at time: ", bt.GetTime());
		node.OnExit(npc, nodesStack.back()[1]);
		nodesStack.pop_back();
	if nodesStack.size() > 0 && enableImmediateExecutionIfNeeded:
		var node:BTNode = nodesStack.back()[0];
		if node.executionDelay == 0:
			node.Execute(npc, nodesStack.back()[1]);

func _EnterNode(node:BTNode)->void:
	print("Blackboard::_EnterNode");
#	if npc.name == "CharacterBody3D2":
#		print("Entering: ", node.name, " at time: ", bt.GetTime());
	nodesStack.append([node, {}]);
	nodesStack.back()[0].OnEnter(npc, nodesStack.back()[1]);
	if nodesStack.back()[0].executionDelay == 0:
		nodesStack.back()[0].Execute();

func RestartBT()->void:
	print("Blackboard::RestartBT");
	while !nodesStack.is_empty():
		_ExitCurrentNode(false);

func _exit_tree()->void:
	print("Blackboard::_exit_tree");
	RestartBT();
	nodesStack.clear();
	if bt:
		bt.blackboards.erase(self);

func Process(delta: float)->void:
	print("Blackboard::Process");
	dt = delta;
	if nodesStack.size() == 0:
		nodesStack.append([bt.rootNode, {}]);
		bt.rootNode.OnEnter(npc, nodesStack.back()[1]);
	nodesStack.back()[0].Execute(npc, nodesStack.back()[1]);

