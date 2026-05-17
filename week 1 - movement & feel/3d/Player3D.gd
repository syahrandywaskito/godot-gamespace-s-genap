class_name Player3D
extends CharacterBody3D

@export var max_health: float = 100

@export_group("Movement")
@export var move_speed: float = 0
@export var accelaration: float = 0
@export var rotation_speed: float = 0	
@export var jump_force: float = 0

@export_group("Feel")
@export var coyote_time: float = 0
@export var jump_buffer_time: float = 0

@export_group("Physics")
@export var push_force: float = 4.0

@onready var cam_controller: TPPCameraController = $TPPCameraController
@onready var visual: Node3D = $Visual

var _last_movement_direction: Vector3 = Vector3.ZERO
var _gravity: float = -45
var _coyote_timer: float = 0
var _jump_buffer_timer: float = 0
var _current_health: float = 0
var _external_speed_multiplier: float = 1.0

func get_current_health() -> float:
	return _current_health

func _ready() -> void:
	_current_health = max_health

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		_coyote_timer -= delta
	else:
		_coyote_timer = coyote_time
	
	var raw_input := Input.get_vector("left", "right", "up", "down")
	var move_direction := cam_controller.get_forward() * raw_input.y + cam_controller.get_right() * raw_input.x 
	move_direction.y = 0
	move_direction = move_direction.normalized()
	
	var velocity_y = velocity.y
	velocity.y = 0.0
	velocity = move_direction * get_effective_move_speed()
	velocity.y = velocity_y + _gravity * delta
	
	if Input.is_action_just_pressed("jump"):
		_jump_buffer_timer = jump_buffer_time
	
	_jump_buffer_timer -= delta

	if _jump_buffer_timer > 0 and _coyote_timer > 0:
		velocity.y = jump_force
		_jump_buffer_timer = 0
		_coyote_timer = 0
	
	move_and_slide()
	force_impulse()
	
	if move_direction.length() > 0.2:
		_last_movement_direction = move_direction
	
	var target_angle := Vector3.BACK.signed_angle_to(_last_movement_direction, Vector3.UP)
	visual.global_rotation.y = lerp_angle(visual.rotation.y, target_angle, rotation_speed * delta)

func force_impulse() -> void:
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		var collider = collision.get_collider()
		
		if collider is RigidBody3D:
			var direction = -collision.get_normal()
			
			if collider.is_in_group("Pushable"):
				collider.apply_central_force(direction * push_force)
			
			if collider.is_in_group("Kickable"):
				collider.apply_central_impulse(direction * push_force)

func take_damage(damage: float) -> void:
	_current_health -= damage


func heal(amount: float) -> void:
	_current_health = min(_current_health + amount, max_health)


func set_external_speed_multiplier(multiplier: float) -> void:
	_external_speed_multiplier = max(multiplier, 0.0)


func get_effective_move_speed() -> float:
	return move_speed * _external_speed_multiplier
