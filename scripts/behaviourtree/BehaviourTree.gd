extends Node;
class_name BehaviourTree;

var character : CharacterBaseController;
var rootNode : BTSelector;
var currentNodes : Array;
var dt : float = 1.0/60.0;

enum BTNodeFinishState {
	FAILURE,
	SUCCESS,
};

var previousNodeFinishState : int = BTNodeFinishState.SUCCESS;

static func Create(c : CharacterBaseController)-> BehaviourTree:
	var bt : BehaviourTree = BehaviourTree.new();
	bt.character = c;
	bt.rootNode = BTSelector.new();
	bt.rootNode.bt = bt;
	return bt;

func _ExitCurrentNode(enableImmediateExecutionIfNeeded:bool)->void:
	if currentNodes.size() > 0:
		var node:BTNode = currentNodes.back();
		node.OnExit();
		currentNodes.pop_back();
	if currentNodes.size() > 0 && enableImmediateExecutionIfNeeded:
		var node:BTNode = currentNodes.back();
		if node.executionDelay == 0:
			node.Execute();

func _EnterNode(node:BTNode)->void:
	currentNodes.append(node);
	currentNodes.back().OnEnter();
	if currentNodes.back().executionDelay == 0:
		currentNodes.back().Execute();

func RestartBT():
	var i:int = currentNodes.size()-1;
	while i>=0:
		currentNodes[i].OnExit();
		i-=1;
	currentNodes.clear();
	previousNodeFinishState = self.SUCCESS;

func _exit_tree()->void:
	currentNodes.clear();
	rootNode.Destroy();
	rootNode.free();
	rootNode = null;

func _ready():
	character = get_parent();

func _process(delta: float)->void:
	dt = delta;

func _physics_process(delta:float)->void:
	dt = delta;
	if currentNodes.size() == 0:
		currentNodes.append(rootNode);
		rootNode.OnEnter();
	currentNodes.back().Execute();

