@tool
extends NavigationRegion3D;

@export var rebuildingEditor:bool = true;
@export var rebuildingGame:bool = true;
@export var waitTimeBetweenRebakeEditor:float = 10;
@export var waitTimeBetweenRebakeGame:float = 5;
var rebuildNavMesh:bool = true;
var time:float = 0;

func _ready() -> void:
#	navigation_mesh_changed.connect(OnNavigationMeshChanged);
	bake_finished.connect(OnNavigationMeshChanged);

func _process(delta: float) -> void:
	if Engine.is_editor_hint():
		if rebuildingEditor:
			time += delta;
			if rebuildNavMesh:
				if time >= waitTimeBetweenRebakeEditor:
					rebuildNavMesh = false;
					bake_navigation_mesh();
	else:
		if rebuildingGame:
			time += delta;
			if rebuildNavMesh:
				if time >= waitTimeBetweenRebakeGame:
					rebuildNavMesh = false;
					bake_navigation_mesh();


func OnNavigationMeshChanged()->void:
	rebuildNavMesh = true;
	time = 0;
