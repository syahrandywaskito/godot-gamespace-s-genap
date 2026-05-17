extends Area2D

@export var speed: float = 900.0
@export var max_lifetime: float = 4.0
@export var camera_margin: float = 64.0

var _direction: Vector2 = Vector2.UP
var _life_left: float = 0.0


func _ready() -> void:
	_life_left = max_lifetime


func setup(direction: Vector2) -> void:
	if direction != Vector2.ZERO:
		_direction = direction.normalized()
	rotation = _direction.angle() + PI * 0.5


func _physics_process(delta: float) -> void:
	global_position += _direction * speed * delta
	_life_left -= delta

	if _life_left <= 0.0:
		queue_free()
		return

	if _is_outside_active_camera():
		queue_free()


func _is_outside_active_camera() -> bool:
	var camera := get_viewport().get_camera_2d()
	if camera == null:
		return false

	var half_size := get_viewport_rect().size
	var center := camera.get_screen_center_position()
	var limit_min := center - half_size - Vector2.ONE * camera_margin
	var limit_max := center + half_size + Vector2.ONE * camera_margin

	return (
		global_position.x < limit_min.x
		or global_position.x > limit_max.x
		or global_position.y < limit_min.y
		or global_position.y > limit_max.y
	)
