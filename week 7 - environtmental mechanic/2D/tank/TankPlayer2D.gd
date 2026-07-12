extends CharacterBody2D
class_name TankPlayer2D

@export var move_speed: float = 220.0
@export var rotation_lerp_speed: float = 14.0
@export var bullet_scene: PackedScene
@export var shoot_cooldown: float = 0.2
@export var muzzle_distance: float = 54.0
@export var knockback_force: float = 300.0
@export var knockback_friction: float = 800.0

@onready var cannon: Node2D = $Cannon
@onready var explode: GPUParticles2D = $Cannon/Explode
@onready var cam_shake: CamShake = $CamShake
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var sprite: Sprite2D = $Sprite2D

const shoot_audio = preload("uid://b3by2q532iko1")

var _pressed_move_directions: Array[Vector2] = []
var _shoot_cooldown_left: float = 0.0
var _shoot_requested: bool = false
var _external_speed_multiplier: float = 1.0
var _boost_multiplier: float = 1.0
var _knockback_velocity: Vector2 = Vector2.ZERO
var _scale_tween: Tween


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and not event.echo:
		match event.physical_keycode:
			KEY_W:
				_set_move_direction_pressed(Vector2.UP, event.pressed)
			KEY_S:
				_set_move_direction_pressed(Vector2.DOWN, event.pressed)
			KEY_A:
				_set_move_direction_pressed(Vector2.LEFT, event.pressed)
			KEY_D:
				_set_move_direction_pressed(Vector2.RIGHT, event.pressed)
		if event.physical_keycode == KEY_SPACE and event.pressed:
			_shoot_requested = true


func _physics_process(delta: float) -> void:
	_shoot_cooldown_left = max(_shoot_cooldown_left - delta, 0.0)
	_knockback_velocity = _knockback_velocity.move_toward(Vector2.ZERO, knockback_friction * delta)
	
	var move_direction := _get_move_direction()
	if move_direction != Vector2.ZERO:
		var target_rotation := move_direction.angle() + PI * 0.5
		rotation = lerp_angle(rotation, target_rotation, min(rotation_lerp_speed * delta, 1.0))
		
	velocity = (move_direction * get_effective_move_speed()) + _knockback_velocity
	
	move_and_slide()
	_handle_shooting()


func _get_move_direction() -> Vector2:
	if _pressed_move_directions.is_empty():
		return Vector2.ZERO
	return _pressed_move_directions.back()


func _handle_shooting() -> void:
	var wants_fire := _shoot_requested
	_shoot_requested = false
	
	if InputMap.has_action("fire") and Input.is_action_just_pressed("fire"):
		explode_particle()
		play_Squish()
		cam_shake.trigger_shake(27.0, 8)
		SoundPool.play_sound(shoot_audio, 2.0, 1.0, true)
		wants_fire = true

	if not wants_fire or _shoot_cooldown_left > 0.0 or bullet_scene == null:
		return
	
	var bullet := bullet_scene.instantiate()
	if bullet == null:
		return

	var bullet_direction := Vector2.UP.rotated(rotation)
	var spawn_position := cannon.to_global(Vector2(0.0, -muzzle_distance))
	bullet.global_position = spawn_position
	
	if bullet.has_method("setup"):
		bullet.call("setup", bullet_direction)
	else:
		bullet.rotation = bullet_direction.angle() + PI * 0.5
	
	var spawn_parent := get_tree().current_scene
	if spawn_parent == null:
		spawn_parent = get_parent()
	spawn_parent.add_child(bullet)
	
	_knockback_velocity = -bullet_direction * knockback_force
	_shoot_cooldown_left = shoot_cooldown

func explode_particle() -> void:
	explode.emitting = false
	explode.restart()
	explode.emitting = true

func play_Squish() -> void:
	if animation_player.is_playing():
		animation_player.stop()
	
	animation_player.play(&"squish")

func _set_move_direction_pressed(direction: Vector2, pressed: bool) -> void:
	_pressed_move_directions.erase(direction)
	if pressed:
		_pressed_move_directions.append(direction)

func set_external_speed_multiplier(multiplier: float) -> void:
	_external_speed_multiplier = max(multiplier, 0.0)

func set_boost_multiplier(multiplier: float) -> void:
	if is_equal_approx(multiplier, _boost_multiplier):
		return
		
	_boost_multiplier = max(multiplier, 1.0)
	
	if _scale_tween and _scale_tween.is_valid():
		_scale_tween.kill()
		
	_scale_tween = create_tween().set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT).set_parallel(true)
	var target_scale_y = 1.25 if _boost_multiplier > 1.0 else 1.0
	var target_scale_x = 0.8 if _boost_multiplier > 1.0 else 1.0
	_scale_tween.tween_property(sprite, "scale:y", target_scale_y, 0.2)
	_scale_tween.tween_property(sprite, "scale:x", target_scale_x, 0.2)

func get_effective_move_speed() -> float:
	return move_speed * _external_speed_multiplier * _boost_multiplier
