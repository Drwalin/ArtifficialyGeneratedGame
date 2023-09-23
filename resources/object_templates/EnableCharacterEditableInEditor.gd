@tool
extends Node;

func _ready()->void:
	SetEditableWhenAvailable();
func _enter_tree()->void:
	SetEditableWhenAvailable();

func SetEditableWhenAvailable()->void:
	if !Engine.is_editor_hint():
		return;
	var character:Node = get_parent().get_parent();
	character.get_parent().set_editable_instance(character, true);
	character.set_editable_instance(get_parent(), false);
	get_parent().set_display_folded(true);
