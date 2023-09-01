extends BTNode;
class_name BTCondition;

var nextNode:BTNode;

func _init(node:BTNode)->void:
	nextNode = node;
	node.bt = bt;

func SetBT(_bt: BehaviourTree)->void:
	super.SetBT(_bt);
	nextNode.SetBT(_bt);

func Destroy()->void:
	super.Destroy();
	nextNode.Destroy();
	nextNode.free();
	nextNode = null;

func OnEnter()->void:
	bt.currentNodes[bt.currentNodes.size()-1] = nextNode;
	nextNode.OnEnter();

func OnExit()->void:
	assert(false);

func Execute()->void:
	assert(false);

func Fail()->void:
	assert(false);

func Success()->void:
	assert(false);

