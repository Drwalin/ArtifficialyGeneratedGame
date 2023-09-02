@tool
extends Label;
class_name BTNode;

var bt : BehaviourTree;

# 0 -> execution immediate from condition and selector and every frame
# 1 -> execution every frame, after condition or selector delayes one frame
# >1 -> delayes approximately given amount of frames between executions
var executionDelay:int = 1;

func _init()->void:
	text = "Node";
	add_theme_color_override("font_color", Color(0.05, 0.9, 0.1));

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

func OnEnter()->void:
	pass;

func OnExit()->void:
	pass;

func Execute()->void:
	pass;

func bb()->BTBlackboard:
	return bt.bb;

func _ready()->void:
	if !Engine.is_editor_hint():
		hide();

func OrientObjects()->void:
	pass;

func GetAABBSize()->Vector2:
	return get_minimum_size();

var orientinObjectsCounter:int = 0;
func _process(delta: float)->void:
	if OS.is_debug_build() && Engine.is_editor_hint():
		orientinObjectsCounter += 1;
		if orientinObjectsCounter%60 == 1:
			delta = delta;
			OrientObjects();

