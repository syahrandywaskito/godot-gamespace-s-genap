extends Node
class_name CamShake

@export var cam: Camera2D = null

var _shake_fade : float = 0
var _shake_strength : float = 0.0

func trigger_shake(cam_max_shake : float, cam_shake_fade: float) -> void:
	_shake_strength = cam_max_shake
	_shake_fade = cam_shake_fade

func _process(delta: float) -> void:
	if _shake_strength > 0:
		_shake_strength = lerp(_shake_strength, 0.0, _shake_fade * delta)
		cam.offset = Vector2(randf_range(-_shake_strength, _shake_strength), randf_range(-_shake_strength, _shake_strength))
