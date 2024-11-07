extends Node

@export var enabled := true
@export var toggleSources :Array[Node]

func _ready():
	for source:Node in toggleSources:
		source.has_signal()

func _on_toggled():
	enabled = not enabled
