extends BTNode;
class_name BTSequence;

var nodes : Array = [];
var lastEntered:int = -1;
var lines : Array = [];

func _init(_nodes:Array = [])->void:
	super();
	AddChildrenNodes(_nodes);
	text = "Sequence Node";
	add_theme_color_override("font_color", Color(0.9, 0.1, 0.8));

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
	for n in _nodes:
		nodes.append(n);
		n.bt = bt;
		add_child(n);
		
		var l = Line2D.new();
		add_child(l);
		lines.append(l);
		l.add_point(Vector2(0,0));
		l.add_point(Vector2(0,0));
		l.width = 4;

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
	set_position(Vector2(0,0));
	super._ready();
	
func GetAABBSize()->Vector2:
	var w:float = 0;
	var h:float = 0;
	for n in nodes:
		var s = n.get_minimum_size();
		w += s.x;
		h = max(h, s.y);
	w += (nodes.size()-1)*30;
	h += 60 + get_minimum_size().y;
	w = max(get_minimum_size().x, w);
	return Vector2(w, h);

func OrientObjects()->void:
	text = "Sequence Node";
	var s = GetAABBSize();
	var w:float = -s.x/2 + size.x/2;
	for i in range(0, nodes.size()):
		var n:BTNode = nodes[i];
		var a = n.GetAABBSize();
		w += a.x/2;
		n.set_position(Vector2(w-n.get_minimum_size().x/2, get_minimum_size().y+60));
		w += 30 + a.x/2;
		
		var l:Line2D = lines[i];
		if nodes.size() > 1:
			l.set_point_position(0, Vector2(get_minimum_size().x*(0.5+(float(i)/(nodes.size()-1)))*0.5,30));
		else:
			l.set_point_position(0, Vector2(get_minimum_size().x/2,30));
		l.set_point_position(1, n.position + Vector2(n.get_minimum_size().x/2, 0));
		l.position = Vector2(0,0);
		
	
