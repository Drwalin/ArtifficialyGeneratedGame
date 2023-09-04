extends CharacterBaseController;
class_name CharacterBaseAI;

@export var behaviourTree:BehaviourTree;
@onready var blackboard:BTBlackboard = $BTBlackboard;
@onready var navigationAgent:NavigationAgent3D = $NavigationAgent3D;

func _ready()->void:
	navigationAgent.set_navigation_map(get_tree().root.child("NavigationRegion3D").get_region_rid());
	blackboard.npc = self;
	blackboard.SetBehaviourTree(behaviourTree);
	rotateTowardMovementDirection = true;

func _physics_process(delta: float) -> void:
	var nextPathPosition: Vector3 = navigationAgent.get_next_path_position();
	var direction: Vector3 = (nextPathPosition - global_position).normalized();
	SetGlobalMoveDirection(direction);
	super._physics_process(delta);
