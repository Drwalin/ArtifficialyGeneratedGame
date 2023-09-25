extends CharacterControllerMovement;
class_name CharacterBaseController;

@export var characterNickName:String = "";
@export var handReachRange:float = 4;

@onready var inventoryStorage:InventoryStorage = $InventoryStorage;

func TryInteractInHeadCenterDirection()->void:
	TryInteractInDirection(head.global_position, head.global_transform.basis*Vector3.FORWARD);

func TryInteractInDirection(from:Vector3, dir:Vector3)->void:
	var space:PhysicsDirectSpaceState3D = get_world_3d().direct_space_state;
	var query:PhysicsRayQueryParameters3D = PhysicsRayQueryParameters3D.new();
	query.from = from;
	query.to = from + dir.normalized()*handReachRange;
	query.exclude = [self];
	var result = space.intersect_ray(query);
	if result:
		if result.collider.has_method("OnUseByCharacter"):
			result.collider.OnUseByCharacter(self);
		elif result.collider.get_parent().has_method("OnUseByCharacter"):
			result.collider.get_parent().OnUseByCharacter(self);


