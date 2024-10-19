extends RigidBody2D

enum BoxFragility{FRAGILE, NORMAL, INDESTRUCTIBLE}

@export var box_fragility = BoxFragility.NORMAL

func _ready():
	match box_fragility:
		BoxFragility.FRAGILE:
			$Sprite2D.texture = preload("res://Tile/box_fragile.tres")
			$Hitbox.set_collision_mask_value(5, true)
			$Hitbox.set_collision_mask_value(6, true)
			$Hitbox.set_collision_mask_value(7, true)
			mass = 1
		BoxFragility.NORMAL:
			$Sprite2D.texture = preload("res://Tile/box_regular.tres")
			$Hitbox.set_collision_mask_value(5, false)
			$Hitbox.set_collision_mask_value(6, true)
			$Hitbox.set_collision_mask_value(7, false)
			mass = 1
		BoxFragility.INDESTRUCTIBLE:
			$Sprite2D.texture = preload("res://Tile/box_indestructible.tres")
			$Hitbox.set_collision_mask_value(5, false)
			$Hitbox.set_collision_mask_value(6, false)
			$Hitbox.set_collision_mask_value(7, false)
			mass = 5
func _on_hitbox_hit():
	#play destroy sound
	queue_free()
