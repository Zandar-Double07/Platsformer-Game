extends Area2D
signal onHit

	


func _on_hazard_entered(_area):
	onHit.emit()
