extends Node2D
signal all_keys_collected
func _ready():
	var door:Door = get_tree().current_scene.find_child("Door")
	if door:
		all_keys_collected.connect(door.set_unlocked)


func _on_hitbox_hit():
	queue_free()
	self.remove_from_group("keys")
	if(get_tree().get_nodes_in_group("keys").size() == 0):
		all_keys_collected.emit()
