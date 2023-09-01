extends Object;
class_name BTNode;

var bt : BehaviourTree;

# 0 -> execution immediate from condition and selector and every frame
# 1 -> execution every frame, after condition or selector delayes one frame
# >1 -> delayes approximately given amount of frames between executions
var executionDelay:int = 1;

func SetBT(_bt: BehaviourTree)->void:
	bt = _bt;

func Destroy()->void:
	bt = null;

func SetExecutionDelay(value:int)->BTNode:
	executionDelay = value;
	if executionDelay<0:
		executionDelay = 0;
	return self;

func Fail()->void:
	OnExit();
	bt.previousNodeFinishState = bt.FAILURE;
	bt.ExitCurrentNode();

func Success()->void:
	OnExit();
	bt.previousNodeFinishState = bt.SUCCESS;
	bt.ExitCurrentNode();

func CanEnter()->bool:
	return true;

func OnEnter()->void:
	pass;

func OnExit()->void:
	pass;

func Execute()->void:
	pass;

