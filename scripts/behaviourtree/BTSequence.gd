@tool
extends BTNode;
class_name BTSequence;

var nodes : Array = [];

func _init()->void:
	super();
	nodeName = "Sequence Node";
	add_theme_color_override("font_color", Color(0.9, 0.1, 0.8));

func SetBT(_bt: BehaviourTree)->void:
	super.SetBT(_bt);
	for n in nodes:
		n.SetBT(_bt);

func OnEnter(npc:CharacterBaseAI, data:Dictionary)->void:
	data["lastEntered"] = -1;
	bb().previousNodeFinishState = BTBlackboard.BTNodeFinishState.SUCCESS;

func OnExit(npc:CharacterBaseAI, data:Dictionary)->void:
	data["lastEntered"] = -1;

func Execute(npc:CharacterBaseAI, data:Dictionary)->void:
	if bb().previousNodeFinishState == BTBlackboard.BTNodeFinishState.FAILURE:
		return Fail();
	bb().previousNodeFinishState = BTBlackboard.BTNodeFinishState.SUCCESS;
	while data["lastEntered"]+1 < nodes.size():
		data["lastEntered"] += 1;
		if npc.name == "CharacterBody3D2":
			print("Entering at index: ", data["lastEntered"]);
		bb()._EnterNode(nodes[data["lastEntered"]]);
		return;
	if npc.name == "CharacterBody3D2":
		print("Leaving sequence execute after loop at index: ", data["lastEntered"]);
	Success();

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
