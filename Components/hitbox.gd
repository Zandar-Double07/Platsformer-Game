extends Area2D
signal onHit

	


func _on_hazard_entered(area):
	emit_signal("onHit")
