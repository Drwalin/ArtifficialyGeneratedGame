extends CharacterBaseController;

const SENSITIVITY = 0.002;

const BOB_FREQ = 2.0;
const BOB_AMP = 0.08;
var bob_time = 0.0;

var camera : Camera3D;
var selfInventoryUI:InventoryUI = null;

var draggingWorldRigidbodySince = null;

func _ready()->void:
	PrintDebug.Print("Player::_ready");
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED);
	camera = Camera3D.new();
	head.add_child(camera);
	collisionShape.get_child(0).remove_child(collisionShape.get_child(0).get_child(0));

func _input(event)->void:
	PrintDebug.Print("Player::_unhandled_input");
	if selfInventoryUI == null:
		if event is InputEventMouseMotion:
			Rotate(-event.relative.y * SENSITIVITY, -event.relative.x * SENSITIVITY);
		if event is InputEventMouseButton:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED);
	if event is InputEventKey:
		if event.keycode == KEY_ESCAPE:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE);
			if OS.is_debug_build():
				get_tree().quit();

var ui2;
func _process(delta: float)->void:
	if Input.is_action_just_pressed("open_self_inventory"):
		if selfInventoryUI == null:
			selfInventoryUI = load("res://addons/inventory_system/ui/InventoryUI.tscn").instantiate();
			selfInventoryUI.storage = self.inventoryStorage;
			add_child(selfInventoryUI);
			selfInventoryUI.set_position(Vector2(650, 200));
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE);
			selfInventoryUI.owner = null;
			
			ui2 = load("res://addons/inventory_system/ui/InventoryUI.tscn").instantiate();
			ui2.storage = get_parent().find_child("CharacterBody3D3").inventoryStorage;
			add_child(ui2);
			ui2.owner = null;
			ui2.set_position(Vector2(150, 200));
		else:
			remove_child(selfInventoryUI);
			selfInventoryUI = null;
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED);
			
			remove_child(ui2);
			ui2 = null;

func _physics_process(delta:float)->void:
	PrintDebug.Print("Player::_physics_process");
	if selfInventoryUI == null:
		if Input.is_action_just_pressed("use_or_grab"):
			draggingWorldRigidbodySince = Time.get_unix_time_from_system();
			# start grabbing item here
		elif Input.is_action_just_released("use_or_grab"):
			if draggingWorldRigidbodySince+0.2 > Time.get_unix_time_from_system():
				TryInteractInHeadCenterDirection();
		if draggingWorldRigidbodySince && Input.is_action_pressed("use_or_grab"):
			# continue grabbing
			pass;
		else:
			draggingWorldRigidbodySince = null;
		
		SetRunning(Input.is_action_pressed("movement_run"));
		SetCrouching(Input.is_action_pressed("movement_crouch"));
		if Input.is_action_pressed("movement_jump") and is_on_floor():
			Jump();
		var input_dir = Input.get_vector("movement_left", "movement_right", "movement_forward", "movement_backward");
		SetRelativeMoveDirection(input_dir);
	else:
		SetRelativeMoveDirection(Vector2(0,0));
	
	super._physics_process(delta);

	bob_time += delta * Vector3(velocity.x,0,velocity.z).length() * float(is_on_floor());
	camera.transform.origin = _headbob(bob_time);

func _headbob(time) -> Vector3:
	PrintDebug.Print("Player::_headbob");
	var pos = Vector3.ZERO;
	pos.y = sin(time * BOB_FREQ) * BOB_AMP;
	pos.x = cos(time * BOB_FREQ / 2 + PI/2) * BOB_AMP / 2;
	return pos;

