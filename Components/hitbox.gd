extends Area2D
signal onHit



func _on_area_entered(_area):
	onHit.emit()
	print(get_parent().name + ", was hit")
	
func _on_body_entered(_body):
	onHit.emit()
	print(get_parent().name + ", was hit")
	
