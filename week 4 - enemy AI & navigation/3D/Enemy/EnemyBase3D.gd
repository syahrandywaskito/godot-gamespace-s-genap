## Base class untuk musuh 3D.
##
## Mengelola delegasi damage dan pergerakan dasar navigasi 3D.
class_name EnemyBase3D
extends CharacterBody3D

@export var speed: float = 3.0
@onready var nav_agent: NavigationAgent3D = $NavigationAgent3D
@onready var health_component: HealthComponent3D = $HealthComponent3D

func _ready() -> void:
	add_to_group("Enemy")
	if health_component:
		health_component.died.connect(queue_free)

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	move_and_slide()

func move_to_target(target_pos: Vector3, _delta: float) -> void:
	if nav_agent == null: return
	
	nav_agent.target_position = target_pos
	
	if nav_agent.is_navigation_finished():
		velocity = Vector3.ZERO
		return
		
	var next_path_pos = nav_agent.get_next_path_position()
	var current_pos = global_position
	var new_velocity = (next_path_pos - current_pos).normalized() * speed
	
	velocity = new_velocity
	move_and_slide()
	
	# Look at direction of movement (smoothly if possible)
	if velocity.length() > 0.1:
		var look_target = current_pos + velocity
		look_target.y = current_pos.y # Keep upright
		look_at(look_target, Vector3.UP)

func take_damage(amount: float) -> void:
	if health_component:
		health_component.take_damage(amount)
