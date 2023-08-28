@tool
extends EditorScript


# Called when the script is executed (using File -> Run in Script Editor).
func _run():
	print("Hello from the Godot Editor!");
	var r = get_scene();
	print("scene: ", r.name);
	
	var st = SurfaceTool.new();
	
	st.begin(Mesh.PRIMITIVE_TRIANGLES);
	var c = Color(1,1,1);
	var n = Vector3(0,1,0);
	st.set_color(c); st.set_normal(n);
	st.add_vertex(Vector3(1, 0, 0));
	st.set_color(c); st.set_normal(n);
	st.add_vertex(Vector3(1, 0, 1));
	st.set_color(c); st.set_normal(n);
	st.add_vertex(Vector3(0, 0, 1));
	var mesh = st.commit();
	
	var err = ResourceSaver.save(mesh, "res://resources/test.mesh");
	print("error: ", err);
