class_name PlayerFPS
extends CharacterBody3D

@export var sensitivity: float = 0.003
@export var speed: float = 5.0
@export var jump_force: float = 4.5
@export var head: Node3D = null
@export var camera: Camera3D = null

@onready var health_component: HealthComponent3D = $HealthComponent3D

## Getter untuk UI HealthBar3D agar bisa sinkron
func get_current_health() -> float:
	if health_component: return health_component.current_health
	return 0.0

## Getter untuk UI HealthBar3D untuk inisialisasi bar
func get_max_health() -> float:
	if health_component: return health_component.max_health
	return 100.0

func _ready() -> void:
	add_to_group("Player")
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"): 
		if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		head.rotate_y(-event.relative.x * sensitivity)
		camera.rotation.x -= event.relative.y * sensitivity
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-60), deg_to_rad(60))

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_force
	
	_move()
	move_and_slide()

func _move() -> void:
	var input_dir := Input.get_vector("left", "right", "up", "down")
	var direction := (head.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)

func take_damage(amount: float) -> void:
	print("player hitted")
	if health_component:
		health_component.take_damage(amount)
