extends CharacterBaseController;

const SENSITIVITY = 0.002;

const BOB_FREQ = 2.0;
const BOB_AMP = 0.08;
var bob_time = 0.0;

var camera : Camera3D;

func _ready()->void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED);
	camera = Camera3D.new();
	head.add_child(camera);
	collisionShape.get_child(0).remove_child(collisionShape.get_child(0).get_child(0));

func _unhandled_input(event)->void:
	if event is InputEventMouseMotion:
		Rotate(-event.relative.y * SENSITIVITY, -event.relative.x * SENSITIVITY);
	elif event is InputEventKey:
		if event.keycode == KEY_ESCAPE:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE);
			if OS.is_debug_build():
				get_tree().quit();
	elif event is InputEventMouseButton:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED);

func _process(delta: float)->void:
	delta = delta;

func _physics_process(delta:float)->void:
	SetRunning(Input.is_action_pressed("movement_run"));
	SetCrouching(Input.is_action_pressed("movement_crouch"));
	if Input.is_action_pressed("movement_jump") and is_on_floor():
		Jump();
	var input_dir = Input.get_vector("movement_left", "movement_right", "movement_forward", "movement_backward");
	SetRelativeMoveDirection(input_dir);
	super._physics_process(delta);

	bob_time += delta * velocity.length() * float(is_on_floor());
	camera.transform.origin = _headbob(bob_time);

func _headbob(time) -> Vector3:
	var pos = Vector3.ZERO;
	pos.y = sin(time * BOB_FREQ) * BOB_AMP;
	pos.x = cos(time * BOB_FREQ / 2 + PI/2) * BOB_AMP / 2;
	return pos;

