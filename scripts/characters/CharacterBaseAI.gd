extends CharacterBaseController;
class_name CharacterBaseAI;

@export var behaviourTree:BehaviourTree;
@onready var blackboard:BTBlackboard = $BTBlackboard;
@onready var navigationAgent:NavigationAgent3D = $CollisionShape3D/NavigationAgent3D;

var isNavigationFinished:bool = true;

func _ready()->void:
	PrintDebug.Print("CharacterBaseAI::_ready");
	#navigationAgent.set_navigation_map(get_tree().root.child("NavigationRegion3D").get_region_rid());
	blackboard.npc = self;
	blackboard.SetBehaviourTree(behaviourTree);
	SetRotateTowardMovementDirection(true);

func _process(delta: float) -> void:
	isNavigationFinished = navigationAgent.is_navigation_finished();
	PrintDebug.Print("CharacterBaseAI::_process");
	if !isNavigationFinished:
		var nextPathPosition: Vector3 = navigationAgent.get_next_path_position();
		var direction: Vector3 = (nextPathPosition - global_position).normalized();
		SetGlobalMoveDirection(direction);
	else:
		SetGlobalMoveDirection(Vector3.ZERO);
