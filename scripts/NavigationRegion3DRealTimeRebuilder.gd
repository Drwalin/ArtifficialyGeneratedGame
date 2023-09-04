extends NavigationRegion3D

var rebuildNavMesh:bool = true;

func _ready() -> void:
	navigation_mesh_changed.connect(OnNavigationMeshChanged);
	bake_finished.connect(OnNavigationMeshChanged);

func _process(delta: float) -> void:
	if rebuildNavMesh:
		rebuildNavMesh = false;
		bake_navigation_mesh();

func OnNavigationMeshChanged()->void:
	rebuildNavMesh = true;
