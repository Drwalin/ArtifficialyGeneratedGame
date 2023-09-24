extends CharacterBody3D;
class_name CharacterBaseController;

@export var WALK_SPEED:float = 5.0;
@export var RUN_SPEED:float = 9.0;
@export var CROUCH_SPEED:float = 3.0;
@export var JUMP_VELOCITY:float = 4.5;
@export var STANDING_HEIGHT:float = 1.75;
@export var CROUCHING_HEIGHT:float = 1.75/2;
@export var STEP_HEIGHT:float = 0.5;

@export var enableStairsWalking:bool = true;

@export var characterNickName:String = "";
@export var handReachRange:float = 4;

var running: bool = false;
var crouching: bool = false;
var jumped:bool = false;
var justJumped:bool = false;

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

@onready var head:Node3D = $CollisionShape3D/Head;
@onready var collisionShape:CollisionShape3D = $CollisionShape3D;
@onready var capsuleShape = $CollisionShape3D.shape;
@onready var inventoryStorage:InventoryStorage = $InventoryStorage;

#func _ready()->void:
#	if inventoryStorage == null:
#		inventoryStorage = InventoryStorage.new();
#	if inventoryStorage.get_parent() == null:
#		add_child(inventoryStorage);

var moveDirection : Vector3 = Vector3(0,0,0).normalized();
var rotateTowardMovementDirection : bool = false;

func SetRelativeMoveDirection(dir: Vector2)->void:
	PrintDebug.Print("CharacterBaseController::SetRelativeMoveDirection");
	if dir && dir!=Vector2.ZERO:
		var d = Vector3(dir.x, 0, dir.y);
		var dd:Vector3 = (transform.basis * collisionShape.transform.basis * d);
		SetGlobalMoveDirection(dd.normalized());
	else:
		SetGlobalMoveDirection(Vector3.ZERO);

func SetGlobalMoveDirection(dir: Vector3)->void:
	PrintDebug.Print("CharacterBaseController::SetGlobalMoveDirection");
	moveDirection = dir;
	
func SetRotateTowardMovementDirection(_rotate: bool)->void:
	PrintDebug.Print("CharacterBaseController::SetRotateTowardMovementDirection");
	rotateTowardMovementDirection = _rotate;
	
func Rotate(x:float, y:float)->void:
	PrintDebug.Print("CharacterBaseController::Rotate");
	collisionShape.rotate_y(y);
	head.rotate_x(x);
	head.rotation.x = clamp(head.rotation.x, -PI/2, PI/2);

func GetSpeed() -> float:
	PrintDebug.Print("CharacterBaseController::GetSpeed");
	if crouching:
		return CROUCH_SPEED;
	if running:
		return RUN_SPEED;
	return WALK_SPEED;

func Jump()->void:
	PrintDebug.Print("CharacterBaseController::Jump");
	if jumped==false:
		velocity.y = JUMP_VELOCITY;
		jumped = true;
		justJumped = true;
	
	
func SetRunning(value: bool)->void:
	PrintDebug.Print("CharacterBaseController::SetRunning");
	running = value;
	
func SetCrouching(value: bool)->void:
	PrintDebug.Print("CharacterBaseController::SetCrouching");
	if crouching && !value:
		capsuleShape.height = STANDING_HEIGHT;
		transform.origin += Vector3(0, (STANDING_HEIGHT-CROUCHING_HEIGHT)/2, 0);
		crouching = value;
	elif !crouching && value:
		capsuleShape.height = CROUCHING_HEIGHT;
		transform.origin -= Vector3(0, (STANDING_HEIGHT-CROUCHING_HEIGHT)/2, 0);
		crouching = value;

func TryInteractInHeadCenterDirection()->void:
	TryInteractInDirection(head.global_position, head.global_transform.basis*Vector3.FORWARD);

func TryInteractInDirection(from:Vector3, dir:Vector3)->void:
	var space:PhysicsDirectSpaceState3D = get_world_3d().direct_space_state;
	var query:PhysicsRayQueryParameters3D = PhysicsRayQueryParameters3D.new();
	query.from = from;
	query.to = from + dir.normalized()*handReachRange;
	var result = space.intersect_ray(query);
	if result:
		if result.collider.has_method("OnUseByCharacter"):
			result.collider.OnUseByCharacter(self);
		elif result.collider.get_parent().has_method("OnUseByCharacter"):
			result.collider.get_parent().OnUseByCharacter(self);

func _physics_process(delta:float)->void:
	PrintDebug.Print("CharacterBaseController::_physics_process");
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta;

	var speed = GetSpeed();
	if is_on_floor():
		if moveDirection && moveDirection!=Vector3.ZERO:
			velocity.x = moveDirection.x * speed;
			velocity.z = moveDirection.z * speed;
		else: # friction
			velocity.x = move_toward(velocity.x, 0, speed);
			velocity.z = move_toward(velocity.z, 0, speed);
	else:
		velocity.x = lerp(velocity.x, moveDirection.x*speed, delta*3);
		velocity.z = lerp(velocity.z, moveDirection.z*speed, delta*3);
		
	if rotateTowardMovementDirection:
		if velocity.length_squared() > 1:
			var fwdV = (transform.basis*collisionShape.transform.basis * Vector3.FORWARD).normalized();
			var mvV = velocity.normalized();
			var cross = mvV.cross(fwdV);
			var sinV = cross.length();
			var angle = asin(sinV);
			if cross.y>0:
				angle = -angle;
			angle *= min(delta*velocity.length(), 1);
			Rotate(0, angle);
	
	MoveAndSlideAndStairsStep(delta);

func MoveAndSlideAndStairsStep(delta:float)->void:
	# Code copied from (and further modified by Drwalin):
	# https://github.com/godotengine/godot-proposals/issues/2751#issuecomment-1648781190
	# with CC0 License
	# code provided by https://github.com/wareya
	
	if enableStairsWalking && is_on_floor() && !jumped:
		var start_position:Vector3 = global_position
		var wall_test_travel = null
		var wall_collision = null
		# step 1: upwards trace
		var ceiling_collision = move_and_collide(STEP_HEIGHT * Vector3.UP)
		var ceiling_travel_distance:float = STEP_HEIGHT if not ceiling_collision else abs(ceiling_collision.get_travel().y)
		# step 2: "check if there's a wall" trace
		wall_test_travel = velocity * delta
		wall_collision = move_and_collide(wall_test_travel)
		# step 3: downwards trace
		var floor_collision = move_and_collide(Vector3.DOWN * (ceiling_travel_distance + (STEP_HEIGHT if is_on_floor() else 0.0)))
		if floor_collision and floor_collision.get_collision_count() > 0 and acos(floor_collision.get_normal(0).y) < floor_max_angle:
			# if we found stairs, climb up them
			var old_velocity = velocity
			if wall_collision and wall_test_travel.length_squared() > 0.0:
				# try to apply the remaining travel distance if we hit a wall
				var remaining_factor = wall_collision.get_remainder().length() / wall_test_travel.length()
				velocity *= remaining_factor
				move_and_slide()
				velocity /= remaining_factor
			else:
				# even if we didn't hit a wall, we still need to use move_and_slide to make is_on_floor() work properly
				var old_vel = velocity
				velocity = Vector3()
				move_and_slide()
				velocity = old_vel
		else:
			# no stairs, do "normal" non-stairs movement
			global_position = start_position
			move_and_slide()
	else:
		move_and_slide();
		if justJumped:
			justJumped = false;
		elif jumped:
			if is_on_floor() == true:
				jumped = false;
	
