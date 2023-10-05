@tool
class_name ItemMeshUtil;

var surf:SurfaceTool;
var mesh:Mesh;
var item:Item;
var tex:Texture2D;
var im:Image;
var mat:StandardMaterial3D;

func CreateMinecraftStyleMeshFromIcon(item:Item)->void:
	surf = SurfaceTool.new();
	tex = item.icon;
	if tex is AtlasTexture:
		im = tex.atlas.get_image().get_region(tex.region);
	else:
		im = tex.get_image();
	mat = StandardMaterial3D.new();
	surf.begin(Mesh.PRIMITIVE_TRIANGLES);
	surf.set_material(mat);
	ProcessImage();
	mat.albedo_texture = tex if !(tex is AtlasTexture) else tex.atlas;
	mat.texture_filter = BaseMaterial3D.TEXTURE_FILTER_NEAREST;
	#mat.vertex_color_use_as_albedo = true;
	mesh = surf.commit();
	var aabb = mesh.get_aabb();
	var trans = -aabb.get_center();
	surf = SurfaceTool.new();
	surf.append_from(mesh, 0, Transform3D(Basis(), trans));
	surf.set_material(mat);
	mesh = surf.commit();
	GenerateInertia(item, trans);
	surf = null;

func GenerateInertia(item:Item, trans:Vector3)->void:
	var massDivider:float = 0;
	var w:int = im.get_width();
	var h:int = im.get_height();
	for x in range(0,w):
		for y in range(0,h):
			if im.get_pixel(x,y).a > 0.1:
				massDivider += 1.0;
	if massDivider == 0:
		item.inertia = Vector3(0,0,0);
		return;
	var inertia:Vector3 = Vector3(0,0,0);
	for x in range(0,w):
		for y in range(0,h):
			if im.get_pixel(x,y).a > 0.1:
				var v:Vector3 = (Vector3(x,y,0)/16.0+trans);
				var i:Vector3;
				i.x = Vector3(0,v.y,v.z).length();
				i.y = Vector3(v.x,0,v.z).length();
				i.z = Vector3(v.x,v.y,0).length();
				
				v = i;
				v.x *= v.x;
				v.y *= v.y;
				v.z *= v.z;
				inertia += v;
	item.inertia = inertia*4/massDivider;




func ProcessImage():
	var _x:int = 0;
	var _y:int = 0;
	var w:int = im.get_width();
	var h:int = im.get_height();
#	if tex is AtlasTexture:
#		_x = tex.region.position.x;
#		_y = tex.region.position.y;
#		w = tex.region.size.x;
#		h = tex.region.size.y;
	for x in range(_x,w):
		for y in range(_y,h):
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
	var z:Vector3 = Vector3(p.x, p.y, 0)/64.0;
	var x:Vector3 = Vector3(1,0,0) if n.x==0 else Vector3(0,1,0);
	var y:Vector3 = Vector3(1,1,1) - x - Vector3(abs(n.x), abs(n.y), abs(n.z));
	#x *= Vector3(1,1,3);
	#y *= Vector3(1,1,3);
	if n.x > 0:
		AddFinalSquare(Vector3(p.x+1,p.y,0), n, c, x, y);
	elif n.y > 0:
		AddFinalSquare(Vector3(p.x,p.y+1,0), n, c, x, y);
	elif n.z > 0:
		AddFinalSquare(Vector3(p.x,p.y,1), n, c, x, y);
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
	var uv:Vector2;
	if n.y != 0:
		uv = Vector2(p.x/im.get_width(),(p.y-n.y/2)/im.get_height());
	else:
		uv = Vector2(p.x/im.get_width(),p.y/im.get_height());
	if tex is AtlasTexture:
		var at:AtlasTexture = tex;
		var reg = at.region;
		uv = (reg.size * uv + reg.position) / Vector2(tex.get_size() if !(tex is AtlasTexture) else tex.atlas.get_size());
	surf.set_uv(uv);
	#surf.set_color(c);
	surf.set_normal(n);
	surf.add_vertex(p/16.0);

static func GenerateMeshAndShapeForItem(item:Item)->void:
	var meshUtil:ItemMeshUtil = ItemMeshUtil.new();
	meshUtil.item = item
	meshUtil.CreateMinecraftStyleMeshFromIcon(item);
	item.mesh3D = meshUtil.mesh;
	item.shape3D = meshUtil.mesh.create_convex_shape(true, true);
