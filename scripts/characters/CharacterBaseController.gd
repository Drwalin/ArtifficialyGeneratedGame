extends CharacterBody3D;
class_name CharacterBaseController;

const WALK_SPEED = 5.0;
const RUN_SPEED = 9.0;
const CROUCH_SPEED = 3.0;
const JUMP_VELOCITY = 4.5;

var running: bool = false;
var crouching: bool = false;

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

@onready var head = $CollisionShape3D/Head;
@onready var collisionShape = $CollisionShape3D;

var moveDirection : Vector3 = Vector3(0,0,0).normalized();
var rotateTowardMovementDirection : bool = false;

func SetRelativeMoveDirection(dir: Vector2)->void:
	var d = Vector3(dir.x, 0, dir.y);
	var dd:Vector3 = (transform.basis * collisionShape.transform.basis * d);
	SetGlobalMoveDirection(dd.normalized());

func SetGlobalMoveDirection(dir: Vector3)->void:
	moveDirection = dir;
	
func SetRotateTowardMovementDirection(rotate: bool)->void:
	rotateTowardMovementDirection = rotate;
	
func Rotate(x:float, y:float)->void:
		collisionShape.rotate_y(y);
		head.rotate_x(x);
		head.rotation.x = clamp(head.rotation.x, -PI/2, PI/2);

func GetSpeed() -> float:
	if crouching:
		return CROUCH_SPEED;
	if running:
		return RUN_SPEED;
	return WALK_SPEED;

func Jump()->void:
	velocity.y = JUMP_VELOCITY;
	
func SetRunning(value: bool)->void:
	running = value;
	
func SetCrouching(value: bool)->void:
	if crouching && !value:
		collisionShape.scale = Vector3(1,1,1);
		transform.origin += Vector3(0, 0.875/2, 0);
	elif !crouching && value:
		collisionShape.scale = Vector3(1,0.5,1);
		transform.origin -= Vector3(0, 0.875/2, 0);
	
func _physics_process(delta:float)->void:
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta;

	var speed = GetSpeed();
	if is_on_floor():
		if moveDirection:
			velocity.x = moveDirection.x * speed;
			velocity.z = moveDirection.z * speed;
		else: # friction
			velocity.x = move_toward(velocity.x, 0, speed);
			velocity.z = move_toward(velocity.z, 0, speed);
	else:
		velocity.x = lerp(velocity.x, moveDirection.x*speed, delta*3);
		velocity.z = lerp(velocity.z, moveDirection.z*speed, delta*3);
		
	if rotateTowardMovementDirection:
		if velocity.length_squared() > 0.01:
			var fwdV = (transform.basis*collisionShape.transform.basis * Vector3.FORWARD).normalized();
			var mvV = velocity.normalized();
			var sinV = mvV.cross(fwdV);
			var angle = asin(sinV);
			Rotate(0, angle);
	move_and_slide();

