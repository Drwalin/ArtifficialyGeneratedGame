extends Control;

func _can_drop_data(pos:Vector2, data)->bool:
	if data is ItemDragData:
		var dropData:ItemDragData = data;
		if dropData.storage:
			if dropData.storage.canDropOnGround:
				return true;
	return false;

var droppedScenePreloaded = preload("res://addons/inventory_system/world/ItemDropped3D.tscn");
func _drop_data(pos:Vector2, _data):
	if _data is ItemDragData:
		var data:ItemDragData = _data;
		var dropped:ItemDropped3D = droppedScenePreloaded.instantiate();
		get_tree().root.add_child(dropped);
		if data.amount == data.itemStack.amount:
			dropped.Init([data.itemStack]);
			data.amount = data.itemStack.amount;
		else:
			var stack:ItemStack = ItemStack.new();
			stack.amount = data.amount;
			stack.item = data.itemStack.item;
			stack.tag = data.itemStack.tag;
			data.itemStack.AddAmount(-data.amount);
			data.amount = 0;
			dropped.Init([stack]);
		
		var cam:Camera3D = get_viewport().get_camera_3d();
		var space:PhysicsDirectSpaceState3D = cam.get_world_3d().direct_space_state;
		var orig:Vector3 = cam.project_ray_origin(pos);
		var rayEnd:Vector3 = orig + cam.project_ray_normal(pos) * 5.0;
		var query:PhysicsRayQueryParameters3D = PhysicsRayQueryParameters3D.new();
		query.from = orig;
		query.to = rayEnd;
		query.exclude = [cam.get_parent().get_parent().get_parent()];
		var result = space.intersect_ray(query);
		var dropPoint:Vector3 = rayEnd;
		var rotang:float = randf()*2*PI;
		dropped.rotate(Vector3(0,1,0), rotang);
		dropped.position = dropPoint;
		if result:
			dropPoint = result.position;
			dropped.position = dropPoint;
			var n0:Vector3 = Vector3(0,0,1).rotated(Vector3(0,1,0), rotang);
			var n1:Vector3 = result.normal;
			var n:Vector3 = n0.cross(n1);
			var l:float = n.length();
			var dot:float = n0.dot(n1);
			n = n.normalized();
			dropped.rotate(n, atan2(l, dot));#asin(l));
			dropped.position += n1*1.0/16.0;
		dropped.rotate_x(randf()*0.1);
		dropped.rotate_z(randf()*0.1);
