extends BTNode;
class_name BTCondition;

var executionNode:BTNode;
var line:Line2D;

func _init(node:BTNode)->void:
	super();
	executionNode = node;
	node.bt = bt;
	add_child(node);
	text = "Condition Node";
	add_theme_color_override("font_color", Color(0.9, 0.1, 0.05));
	line = Line2D.new();
	add_child(line);
	line.width = 5;
	line.add_point(Vector2(0,0));
	line.add_point(Vector2(0,0));
	line.default_color = Color(0,0,0.9);

func SetBT(_bt: BehaviourTree)->void:
	super.SetBT(_bt);
	executionNode.SetBT(_bt);

func Destroy()->void:
	super.Destroy();
	executionNode.Destroy();
	executionNode.free();
	executionNode = null;

func OnEnter()->void:
	if CanExecute():
		bb().nodesStack[bb().nodesStack.size()-1] = executionNode;
		executionNode.OnEnter();
	bt.previousNodeFinishState = bt.SUCCESS;
	bt.ExitCurrentNode();
	
func CanExecute()->bool:
	assert(false, "Not implemented BTCondition::CanExecute().");
	return false;

func OnExit()->void:
	assert(false);

func Execute()->void:
	assert(false);
	
func _ready()->void:
	set_position(Vector2(0,0));
	super._ready();

func GetAABBSize()->Vector2:
	var s = executionNode.GetAABBSize();
	var h = s.y + 30 + get_minimum_size().y;
	var w = max(get_minimum_size().x, s.x);
	return Vector2(w, h);

func OrientObjects()->void:
	text = "Condition Node";
	var a = executionNode.GetAABBSize();
	var v = Vector2(
		get_minimum_size().x/2-a.x/2,
		get_minimum_size().y+60)
	executionNode.set_position(v);
	line.set_point_position(0, size*Vector2(0.5,1));
	line.set_point_position(1, executionNode.position+executionNode.size*Vector2(0.5,0));

