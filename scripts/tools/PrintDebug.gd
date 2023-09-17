extends Object
class_name PrintDebug;

static var enabled:bool = false;

static func Print(args)->void:
	if enabled:
		print(args);
