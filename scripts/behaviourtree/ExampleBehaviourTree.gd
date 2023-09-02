@tool
extends BehaviourTree;
class_name ExampleBehaiourTree;

func _init()->void:
	super();
	rootNode.AddChildrenNodes([
		BTCondition.new(BTNode.new()),
		BTSequence.new([
			BTSequence.new([
				BTNode.new(),
				BTNode.new(),
				BTNode.new()
			]),
			BTNode.new(),
			BTNode.new(),
			BTNode.new()
			])
		]);
	print("Example behaviour constructor");

