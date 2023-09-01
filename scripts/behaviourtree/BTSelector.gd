extends BTNode;
class_name BTSelector;

var nodes : Array;
var lastEntered:int = -1;

func _init(_nodes:Array)->void:
	AddChildrenNodes(_nodes);

func SetBT(_bt: BehaviourTree)->void:
	super.SetBT(_bt);
	for n in nodes:
		n.SetBT(_bt);

func Destroy()->void:
	for n in nodes:
		n.Destroy();
		n.free();
	super.Destroy();

func AddChildrenNodes(_nodes:Array)->void:
	nodes.append_array(_nodes);
	for n in _nodes:
		n.bt = bt;

func OnEnter()->void:
	super.OnEnter();
	lastEntered = -1;
	bt.previousNodeFinishState = bt.SUCCESS;

func OnExit()->void:
	super.OnExit();
	lastEntered = -1;

func Execute()->void:
	if bt.previousNodeFinishState == bt.FAILURE:
		return Fail();
	bt.previousNodeFinishState = bt.SUCCESS;
	while lastEntered+1 < nodes.size():
		lastEntered += 1;
		if nodes[lastEntered].CanEnter():
			bt._EnterNode(nodes[lastEntered]);
			return;
	return Success();

