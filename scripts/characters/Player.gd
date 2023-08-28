extends CharacterBody3D

const WALK_SPEED = 5.0;
const RUN_SPEED = 9.0;
const CROUCH_SPEED = 3.0;
const JUMP_VELOCITY = 4.5;
const SENSITIVITY = 0.01;

enum MovementState {
	STATE_RUNNING,
	STATE_WALKING,
	STATE_CROUCHING
};
var movementState = MovementState.STATE_WALKING;

const BOB_FREQ = 2.0;
const BOB_AMP = 0.08;
var bob_time = 0.0;

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = 9.81; # ProjectSettings.get_setting("physics/3d/default_gravity")

@onready var head = $Head;
@onready var camera = $Head/Camera;
@onready var collisionShape = $CollisionShape3D;

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED);

func _unhandled_input(event):
	if event is InputEventMouseMotion:
		head.rotate_y(-event.relative.x * SENSITIVITY);
		camera.rotate_x(-event.relative.y * SENSITIVITY);
		camera.rotation.x = clamp(camera.rotation.x, -PI/2, PI/2);
	elif event is InputEventKey:
		if event.keycode == KEY_ESCAPE:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE);
			if OS.is_debug_build():
				get_tree().quit();
	elif event is InputEventMouseButton:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED);

func _process(delta):
	movementState = MovementState.STATE_WALKING;
	if Input.is_action_pressed("movement_run"):
		movementState = MovementState.STATE_RUNNING;
	if Input.is_action_pressed("movement_crouch"):
		movementState = MovementState.STATE_CROUCHING;

func _get_speed() -> float:
	match movementState:
		MovementState.STATE_RUNNING:
			return RUN_SPEED;
		MovementState.STATE_CROUCHING:
			return CROUCH_SPEED;
		MovementState.STATE_WALKING:
			return WALK_SPEED;
	# throw error
	return WALK_SPEED;

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta;

	if Input.is_action_just_pressed("movement_crouch"):
		collisionShape.scale = Vector3(1,0.5,1);
		transform.origin -= Vector3(0, 0.875/2, 0);
	elif Input.is_action_just_released("movement_crouch"):
		collisionShape.scale = Vector3(1,1,1);
		transform.origin += Vector3(0, 0.875/2, 0);

	# Handle Jump.
	if Input.is_action_pressed("movement_jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY;

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("movement_left", "movement_right", "movement_forward", "movement_backward");
	var direction = (head.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized();
	var speed = _get_speed();
	if is_on_floor():
		if direction:
			velocity.x = direction.x * speed;
			velocity.z = direction.z * speed;
		else: # friction
			velocity.x = move_toward(velocity.x, 0, speed);
			velocity.z = move_toward(velocity.z, 0, speed);
	else:
		velocity.x = lerp(velocity.x, direction.x*speed, delta*3);
		velocity.z = lerp(velocity.z, direction.z*speed, delta*3);

	bob_time += delta * velocity.length() * float(is_on_floor());
	camera.transform.origin = _headbob(bob_time);

	move_and_slide();

func _headbob(time) -> Vector3:
	var pos = Vector3.ZERO;
	pos.y = sin(time * BOB_FREQ) * BOB_AMP;
	pos.x = cos(time * BOB_FREQ / 2 + PI/2) * BOB_AMP / 2;
	return pos;




