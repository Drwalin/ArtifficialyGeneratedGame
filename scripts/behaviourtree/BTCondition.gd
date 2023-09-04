@tool
extends BTNode;
class_name BTCondition;

var node:BTNode;
var conditionExpression:Expression = Expression.new();
@export var condition: String = "";

func _init()->void:
	super();
	lineColor = Color(0,0,0.9);
	nodeName = "Condition Node";
	add_theme_color_override("font_color", Color(0.9, 0.1, 0.05));

func SetBT(_bt: BehaviourTree)->void:
	super.SetBT(_bt);
	node.SetBT(_bt);

func OnEnter()->void:
	if CanExecute():
		bb().nodesStack[bb().nodesStack.size()-1] = node;
		node.OnEnter();
		return;
	bb().previousNodeFinishState = BTBlackboard.BTNodeFinishState.SUCCESS;
	bb()._ExitCurrentNode();
	
func CanExecute()->bool:
	return conditionExpression.execute([bb()], bb().npc);

func OnExit()->void:
	assert(false);

func Execute()->void:
	assert(false);
	
func _ready()->void:
	super._ready();
	set_position(Vector2(0,0));
	var err = conditionExpression.parse(condition, ["bb"]);
	assert(err == OK, conditionExpression.get_error_text());
	for c in get_children():
		if c is BTNode:
			node = c as BTNode;

func GetAABBSize()->Vector2:
	for c in get_children():
		if c is BTNode:
			node = c;
			var s = node.GetAABBSize();
			var h = s.y + 30 + size.y;
			var w = max(size.x, s.x);
			return Vector2(w, h);
	return size;

func OrientObjects()->void:
	nodeName = "Invalid Condition Node";
	if condition != "":
		var err = conditionExpression.parse(condition);
		if err == OK:
			nodeName = condition;
		else:
			nodeName = "Condition error:\n" + conditionExpression.get_error_text();
	size = Vector2(10,10);
	for c in get_children():
		if c is BTNode:
			node = c;
			break;
	if node:
		var a:Vector2 = node.GetAABBSize();
		var v = Vector2(
			size.x/2-a.x/2,
			size.y+60);
		node.set_position(v);

