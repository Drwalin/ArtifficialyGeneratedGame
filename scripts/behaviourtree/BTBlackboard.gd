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
	npc = get_parent();
	SetBehaviourTree(npc.behaviourTree);

func SetBehaviourTree(_bt: BehaviourTree)->void:
	if bt:
		RestartBT();
		bt.blackboards.erase(self);
	bt = _bt;
	if bt:
		bt.blackboards[self] = self;

func _ExitCurrentNode(enableImmediateExecutionIfNeeded:bool=false)->void:
	if nodesStack.size() > 0:
		var node:BTNode = nodesStack.back()[0];
		if npc.name == "CharacterBody3D2":
			print("Leaving: ", node.name, " at time: ", bt.GetTime());
		node.OnExit(npc, nodesStack.back()[1]);
		nodesStack.pop_back();
	if nodesStack.size() > 0 && enableImmediateExecutionIfNeeded:
		var node:BTNode = nodesStack.back()[0];
		if node.executionDelay == 0:
			node.Execute(npc, nodesStack.back()[1]);

func _EnterNode(node:BTNode)->void:
	if npc.name == "CharacterBody3D2":
		print("Entering: ", node.name, " at time: ", bt.GetTime());
	nodesStack.append([node, {}]);
	nodesStack.back()[0].OnEnter(npc, nodesStack.back()[1]);
	if nodesStack.back()[0].executionDelay == 0:
		nodesStack.back()[0].Execute();

func RestartBT()->void:
	var i:int = nodesStack.size()-1;
	while i>=0:
		nodesStack[i][0].OnExit(npc, nodesStack.back()[1]);
		i-=1;
	nodesStack.clear();
	previousNodeFinishState = BTNodeFinishState.SUCCESS;

func _exit_tree()->void:
	RestartBT();
	nodesStack.clear();
	if bt:
		bt.blackboards.erase(self);

func Process(delta: float)->void:
	dt = delta;
	if nodesStack.size() == 0:
		nodesStack.append([bt.rootNode, {}]);
		bt.rootNode.OnEnter(npc, nodesStack.back()[1]);
	nodesStack.back()[0].Execute(npc, nodesStack.back()[1]);

