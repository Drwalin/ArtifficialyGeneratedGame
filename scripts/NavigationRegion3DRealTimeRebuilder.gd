extends NavigationRegion3D

var rebuildNavMesh:bool = true;
var time:float = 0;
var rebuildStartTime:float = 0;

func _ready() -> void:
	navigation_mesh_changed.connect(OnNavigationMeshChanged);
	bake_finished.connect(OnNavigationMeshChanged);

func _process(delta: float) -> void:
	time += delta;
	if rebuildNavMesh:
		if rebuildStartTime < time:
			rebuildNavMesh = false;
			bake_navigation_mesh();
			rebuildStartTime = time + 30;


func OnNavigationMeshChanged()->void:
	rebuildNavMesh = true;
	rebuildStartTime = time + 30;
