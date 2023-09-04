@tool
extends BTNode;
class_name BTSequence;

var nodes : Array = [];
var lastEntered:int = -1;

func _init()->void:
	super();
	text = "Sequence Node";
	add_theme_color_override("font_color", Color(0.9, 0.1, 0.8));

func SetBT(_bt: BehaviourTree)->void:
	super.SetBT(_bt);
	for n in nodes:
		n.SetBT(_bt);

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
		bt._EnterNode(nodes[lastEntered]);
		return;
	return Success();

func _ready()->void:
	super._ready();
	for c in get_children():
		if c is BTNode:
			var node:BTNode = c as BTNode;
			nodes.append(node);
	
func GetAABBSize()->Vector2:
	var w:float = 0;
	var h:float = 0;
	for c in get_children():
		if c is BTNode:
			var n:BTNode = c as BTNode;
			var s = n.GetAABBSize();
			w += s.x;
			h = max(h, s.y);
	w += (nodes.size()-1)*30;
	h += 60 + size.y;
	w = max(size.x, w);
	return Vector2(w, h);

func OrientObjects()->void:
	var s = GetAABBSize();
	var w:float = -s.x/2 + size.x/2;
	for c in get_children():
		if c is BTNode:
			var n:BTNode = c as BTNode;
			var a = n.GetAABBSize();
			w += a.x/2;
			n.set_position(Vector2(w-n.size.x/2, size.y+60));
			w += 30 + a.x/2;
		
	
