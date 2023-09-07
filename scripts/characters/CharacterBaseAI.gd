extends CharacterBaseController;
class_name CharacterBaseAI;

@export var behaviourTree:BehaviourTree;
@onready var blackboard:BTBlackboard = $BTBlackboard;
@onready var navigationAgent:NavigationAgent3D = $NavigationAgent3D;

func _ready()->void:
	print("CharacterBaseAI::_ready");
	#navigationAgent.set_navigation_map(get_tree().root.child("NavigationRegion3D").get_region_rid());
	blackboard.npc = self;
	blackboard.SetBehaviourTree(behaviourTree);
	SetRotateTowardMovementDirection(true);

var everyOtherFrame:int = 0;
func _process(delta: float) -> void:
	print("CharacterBaseAI::_process");
	everyOtherFrame += 1;
	if everyOtherFrame%4 == 0:
		var nextPathPosition: Vector3 = navigationAgent.get_next_path_position();
		var direction: Vector3 = (nextPathPosition - global_position).normalized();
		SetGlobalMoveDirection(direction);

#func _physics_process(delta: float) -> void:
#	super._physics_process(delta);
