extends CharacterBaseAI;

@export var player:Node3D;
@export var target:Node3D;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	blackboard.data["player"] = player;
	blackboard.data["target_object"] = target;
	pass;


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
