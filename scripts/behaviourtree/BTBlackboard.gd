extends Node;
class_name BTBlackboard;

var bt : BehaviourTree
var npc : CharacterBaseAI;
var nodesStack : Array = []; # [[node, {local_variables}]]
var dt : float;
var data = {};
var stack : Array = [];

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
		bt.blackboards[self] = 1;

func _ExitCurrentNode(enableImmediateExecutionIfNeeded:bool=false)->void:
	if nodesStack.size() > 0:
		var node:BTNode = nodesStack.back()[0];
		node.OnExit();
		nodesStack.pop_back();
	if nodesStack.size() > 0 && enableImmediateExecutionIfNeeded:
		var node:BTNode = nodesStack.back()[0];
		if node.executionDelay == 0:
			node.Execute();

func _EnterNode(node:BTNode)->void:
	nodesStack.append([node, {}]);
	nodesStack.back()[0].OnEnter();
	if nodesStack.back()[0].executionDelay == 0:
		nodesStack.back()[0].Execute();

func RestartBT()->void:
	var i:int = nodesStack.size()-1;
	while i>=0:
		nodesStack[i][0].OnExit();
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
		bt.rootNode.OnEnter();
	nodesStack.back()[0].Execute();
