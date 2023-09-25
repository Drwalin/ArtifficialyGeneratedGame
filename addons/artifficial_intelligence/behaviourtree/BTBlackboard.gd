extends Node;
class_name BTBlackboard;

var bt : BehaviourTree;
@onready var npc : CharacterBaseAI = get_parent();
var dt : float;
@export var data = {};

@export_group("Hidden exports")
@export var previousNodeFinishState : BTNodeFinishState = BTNodeFinishState.SUCCESS;
@export var nodesStack : Array[Array] = []; # [[node, {local_variables}]]

enum BTNodeFinishState {
	FAILURE,
	SUCCESS,
};

func _ready()->void:
	PrintDebug.Print("Blackboard::_ready");
	SetBehaviourTree(npc.behaviourTree);

func SetBehaviourTree(_bt: BehaviourTree)->void:
	PrintDebug.Print("Blackboard::SetBehaviourTree");
	if bt:
		RestartBT();
		bt.blackboards.erase(self);
	bt = _bt;
	if bt:
		bt.blackboards[self] = self;

func _ExitCurrentNode(enableImmediateExecutionIfNeeded:bool=false)->void:
	PrintDebug.Print("Blackboard::_ExitCurrentNode");
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
	PrintDebug.Print("Blackboard::_EnterNode");
#	if npc.name == "CharacterBody3D2":
#		print("Entering: ", node.name, " at time: ", bt.GetTime());
	nodesStack.append([node, {}]);
	nodesStack.back()[0].OnEnter(npc, nodesStack.back()[1]);
	if nodesStack.back()[0].executionDelay == 0:
		nodesStack.back()[0].Execute();

func RestartBT()->void:
	PrintDebug.Print("Blackboard::RestartBT");
	while !nodesStack.is_empty():
		_ExitCurrentNode(false);

func _exit_tree()->void:
	PrintDebug.Print("Blackboard::_exit_tree");
	RestartBT();
	nodesStack.clear();
	if bt:
		bt.blackboards.erase(self);

func Process(delta: float)->void:
	PrintDebug.Print("Blackboard::Process");
	dt = delta;
	if nodesStack.size() == 0:
		nodesStack.append([bt.rootNode, {}]);
		bt.rootNode.OnEnter(npc, nodesStack.back()[1]);
	nodesStack.back()[0].Execute(npc, nodesStack.back()[1]);

