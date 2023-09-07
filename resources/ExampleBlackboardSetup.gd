extends CharacterBaseAI;

@export var player:Node3D;
@export var target:Node3D;
@export var target3:Node3D;
@export var target4:Node3D;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super._ready();
	blackboard.data["player"] = player;
	blackboard.data["target_object"] = target;
	blackboard.data["target3"] = target3;
	blackboard.data["target4"] = target4;
