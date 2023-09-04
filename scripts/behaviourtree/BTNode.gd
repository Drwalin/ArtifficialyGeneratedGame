@tool
extends Label;
class_name BTNode;

var bt : BehaviourTree;
var lineToParent : Line2D;
var lineColor: Color = Color(1,1,1);
var nodeName: String = "Node";

# 0 -> execution immediate from condition and selector and every frame
# 1 -> execution every frame, after condition or selector delayes one frame
# >1 -> delayes approximately given amount of frames between executions
var executionDelay:int = 1;

func _init()->void:
	add_theme_color_override("font_color", Color(0.05, 0.9, 0.1));
				

func SetBT(_bt: BehaviourTree)->void:
	#print("Setting BT of: ", name);
	bt = _bt;

func SetExecutionDelay(value:int)->BTNode:
	executionDelay = value;
	if executionDelay<0:
		executionDelay = 0;
	return self;

func Fail()->void:
	OnExit();
	bb().previousNodeFinishState = BTBlackboard.BTNodeFinishState.FAILURE;
	bb().ExitCurrentNode();

func Success()->void:
	OnExit();
	bb().previousNodeFinishState = BTBlackboard.BTNodeFinishState.SUCCESS;
	bb().ExitCurrentNode();

func RestartBT()->void:
	bt.RestartBT();

func OnEnter()->void:
	pass;

func OnExit()->void:
	pass;

func Execute()->void:
	#print("BTNode::Execute()");
	#assert("Cannot execute pure virtual BTNode::Execute() code.");
	pass;

func bb()->BTBlackboard:
	return bt.bb;

func FindBT()->BehaviourTree:
	var p:Node = get_parent();
	while !p is BehaviourTree && p:
		p = p.get_parent();
	return p as BehaviourTree;

func _ready()->void:
	if !bt:
		bt = FindBT();
	set_position(Vector2(0,0));
	if !Engine.is_editor_hint():
		hide();
	for c in get_children():
		if !(c is BTNode):
			remove_child(c);
	self.set_process(false);
	self.set_physics_process(false);

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
			CreateLineToParent();
			text = nodeName;

func CreateLineToParent():
	if OS.is_debug_build() && Engine.is_editor_hint():
		if get_parent():
			if get_parent() is BTNode:
				if lineToParent == null:
					lineToParent = Line2D.new();
					add_child(lineToParent);
					lineToParent.add_point(Vector2(0,0));
					lineToParent.add_point(Vector2(0,0));
					lineToParent.default_color = lineColor;
				lineToParent.set_point_position(0, -position+get_parent().size*Vector2(0.5, 1));
				lineToParent.set_point_position(1, size*Vector2(0.5, 0));
				lineToParent.width = 4;
			else:
				if lineToParent:
					remove_child(lineToParent);
					lineToParent = null;
