extends CharacterBaseController;
class_name CharacterBaseAI;

@export var behaviourTree:BehaviourTree;
var blackboard:BTBlackboard;
var navigationAgent:NavigationAgent3D;

func _init()->void:
	super._init();
	blackboard = $BTBlackboard;
	navigationAgent = $NavigationAgent3D;

func _ready()->void:
	blackboard = $BTBlackboard;
	navigationAgent = $NavigationAgent3D;
	blackboard.npc = self;
	blackboard.SetBehaviourTree(behaviourTree);

func _physics_process(delta: float) -> void:
	pass;
