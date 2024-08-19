extends ColorRect


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	size.x = get_viewport_rect().size.x
	size.y = get_viewport_rect().size.y
	position.x = -size.x / 2
	position.y = -size.y / 2
	var effect = AudioEffectLowPassFilter.new()
	effect.cutoff_hz = 700
	AudioServer.add_bus_effect(0, effect, 0)
