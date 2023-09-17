@tool
extends BTNode;
class_name BTCondition;

var node:BTNode;
var conditionExpression:Expression = Expression.new();
@export var condition: String = "";

func _init()->void:
	PrintDebug.Print("Condition::_init");
	super();
	lineColor = Color(0,0,0.9);
	nodeName = "Condition Node";
	add_theme_color_override("font_color", Color(0.9, 0.1, 0.05));

func SetBT(_bt: BehaviourTree)->void:
	PrintDebug.Print("Condition::SetBT");
	super.SetBT(_bt);
	node.SetBT(_bt);

func OnEnter(npc:CharacterBaseAI, data:Dictionary)->void:
	PrintDebug.Print("Condition::OnEnter");
	if conditionExpression.execute([bb(), npc, data], npc):
		bb().nodesStack[bb().nodesStack.size()-1][0] = node;
		node.OnEnter(npc, data);
		return;
	Success();

func OnExit(npc:CharacterBaseAI, data:Dictionary)->void:
	PrintDebug.Print("Condition::OnExit");
	pass;

func Execute(npc:CharacterBaseAI, data:Dictionary)->void:
	PrintDebug.Print("Condition::Execute");
	assert(false);
	
func _ready()->void:
	PrintDebug.Print("Condition::_ready");
	super._ready();
	set_position(Vector2(0,0));
	if !(OS.is_debug_build() && Engine.is_editor_hint()):
		var err = conditionExpression.parse(condition, ["bb", "npc", "data"]);
		assert(err == OK, conditionExpression.get_error_text());
		for c in get_children():
			if c is BTNode:
				node = c as BTNode;

func GetAABBSize()->Vector2:
	PrintDebug.Print("Condition::GetAABBSize");
	for c in get_children():
		if c is BTNode:
			node = c;
			var s = node.GetAABBSize();
			var h = s.y + 30 + size.y;
			var w = max(size.x, s.x);
			return Vector2(w, h);
	return size;

func OrientObjects()->void:
	PrintDebug.Print("Condition::OrientObjects");
	nodeName = "Invalid Condition Node";
	if condition != "":
		var err = conditionExpression.parse(condition, ["bb", "npc", "data"]);
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

