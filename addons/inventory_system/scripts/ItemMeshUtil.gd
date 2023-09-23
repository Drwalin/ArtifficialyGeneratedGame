class_name ItemMeshUtil;

var surf:SurfaceTool;
var mesh:Mesh;
var item:Item;
var tex:Texture2D;
var im:Image;
var mat:StandardMaterial3D;

func CreateMinecraftStyleMeshFromIcon():
	surf = SurfaceTool.new();
	mat = StandardMaterial3D.new();
	mat.albedo_texture = tex;
	mat.vertex_color_use_as_albedo = true;
	surf.begin(Mesh.PRIMITIVE_TRIANGLES);
	surf.set_material(mat);
	tex = item.icon;
	im = tex.get_image();
	ProcessImage();
	mesh = surf.commit();

func ProcessImage():
	var w:int = im.get_width();
	var h:int = im.get_height();
	for x in range(0,w):
		for y in range(0,h):
			AddPoint(Vector2i(x, y));
	
func AddPoint(p:Vector2i)->void:
	var c:Color = im.get_pixel(p.x, p.y);
	if c.a > 0.1:
		AddSquare(p, Vector3(0,0,1), c);
		AddSquare(p, Vector3(0,0,-1), c);
		if (p.x > 0 && im.get_pixel(p.x-1, p.y).a < 0.1) || p.x == 0:
			AddSquare(p, Vector3(-1,0,0), c);
		if (p.y > 0 && im.get_pixel(p.x, p.y-1).a < 0.1) || p.y == 0:
			AddSquare(p, Vector3(0,-1,0), c);
		if (p.x+1 < im.get_width() && im.get_pixel(p.x+1, p.y).a < 0.1) || p.x+1 == im.get_width():
			AddSquare(p, Vector3(1,0,0), c);
		if (p.y+1 < im.get_height() && im.get_pixel(p.x, p.y+1).a < 0.1) || p.y+1 == im.get_height():
			AddSquare(p, Vector3(0,1,0), c);
		

func AddSquare(p:Vector2i, n:Vector3, c:Color)->void:
	var z:Vector3 = Vector3(p.x, p.y, 0)/16.0;
	var x:Vector3 = Vector3(1,0,0) if n.x==0 else Vector3(0,1,0);
	var y:Vector3 = Vector3(1,1,1) - x - Vector3(abs(n.x), abs(n.y), abs(n.z));
	x *= Vector3(1,1,3);
	y *= Vector3(1,1,3);
	if n.x > 0:
		AddFinalSquare(Vector3(p.x+1,p.y,0), n, c, x, y);
	elif n.y > 0:
		AddFinalSquare(Vector3(p.x,p.y+1,0), n, c, x, y);
	elif n.z > 0:
		AddFinalSquare(Vector3(p.x,p.y,3), n, c, x, y);
	else:
		AddFinalSquare(Vector3(p.x,p.y,0), n, c, x, y);
	

func AddFinalSquare(p:Vector3, n:Vector3, c:Color, x:Vector3, y:Vector3)->void:
	var rev:bool = true if (n.x<0 || n.y>0 || n.z<0) else false;
	if rev:
		AddFinalPoint(p, n, c);
		AddFinalPoint(p+x, n, c);
		AddFinalPoint(p+x+y, n, c);
		AddFinalPoint(p, n, c);
		AddFinalPoint(p+x+y, n, c);
		AddFinalPoint(p+y, n, c);
	else:
		AddFinalPoint(p+y, n, c);
		AddFinalPoint(p+x+y, n, c);
		AddFinalPoint(p, n, c);
		AddFinalPoint(p+x+y, n, c);
		AddFinalPoint(p+x, n, c);
		AddFinalPoint(p, n, c);

func AddFinalPoint(p:Vector3, n:Vector3, c:Color)->void:
	surf.set_color(c);
	surf.set_normal(n);
	surf.add_vertex(p/16.0);

static func GenerateDropMeshForItem(item:Item)->Mesh:
	var meshUtil:ItemMeshUtil = ItemMeshUtil.new();
	meshUtil.item = item
	meshUtil.CreateMinecraftStyleMeshFromIcon();
	return meshUtil.mesh;

static func GenerateDropShapeForItem(item:Item)->Shape3D:
	var mesh:Mesh = item.GetMesh3D();
	if mesh == null:
		return null;
	return mesh.create_convex_shape(true, true);

