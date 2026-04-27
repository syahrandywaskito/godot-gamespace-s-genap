## State Machine 3D untuk mengatur perilaku AI musuh.
##
class_name EnemyStateMachine3D
extends Node

enum State { IDLE, PATROL, CHASE, ATTACK, SEARCH }

@export var initial_state: State = State.IDLE
@export var enemy: EnemyBase3D
@export var vision: VisionComponent3D
@export var sight_cue: Label3D

## Jarak untuk MASUK ke state ATTACK.
@export var attack_enter_range: float = 2.0
## Jarak untuk KELUAR dari state ATTACK kembali ke CHASE.
## Harus lebih besar dari attack_enter_range agar tidak flip-flop.
@export var attack_exit_range: float = 2.8

@export var detection_range: float = 15.0
@export var patrol_points: Array[Vector3] = []

## Berapa lama enemy mencari di last known position sebelum menyerah ke IDLE.
@export var search_duration: float = 3.0

var current_state: State
var state_timer: float = 0.0
var patrol_index: int = 0
var start_pos: Vector3
var _last_known_pos: Vector3 = Vector3.ZERO

func _ready() -> void:
	current_state = initial_state
	start_pos = enemy.global_position

	if patrol_points.is_empty():
		patrol_points.append(start_pos)
		patrol_points.append(start_pos + Vector3(5, 0, 5))

func _physics_process(delta: float) -> void:
	state_timer -= delta
	_update_state_logic(delta)
	_update_visual_cues()

	match current_state:
		State.IDLE:
			_idle_state(delta)
		State.PATROL:
			_patrol_state(delta)
		State.CHASE:
			_chase_state(delta)
		State.ATTACK:
			_attack_state(delta)
		State.SEARCH:
			_search_state(delta)

func change_state(new_state: State) -> void:
	if current_state == new_state:
		return
	current_state = new_state
	match new_state:
		State.SEARCH:
			state_timer = search_duration
		_:
			state_timer = randf_range(2.0, 4.0)

func _update_state_logic(_delta: float) -> void:
	var can_see: bool = vision.can_see_target() if vision else false

	if can_see:
		# Selalu update posisi terakhir selama player terlihat
		_last_known_pos = vision.target.global_position
		var dist: float = enemy.global_position.distance_to(_last_known_pos)

		if dist <= attack_enter_range:
			change_state(State.ATTACK)
		elif dist > attack_exit_range:
			change_state(State.CHASE)
		# else: dead zone -> pertahankan state saat ini

	else:
		# Kehilangan penglihatan -> jangan langsung IDLE, coba cari dulu
		if current_state == State.CHASE or current_state == State.ATTACK:
			change_state(State.SEARCH)

		# Setelah search timeout -> IDLE
		if current_state == State.SEARCH and state_timer <= 0:
			change_state(State.IDLE)

		# Setelah idle timeout -> patroli
		if current_state == State.IDLE and state_timer <= 0:
			change_state(State.PATROL)

func _update_visual_cues() -> void:
	if sight_cue == null:
		return

	match current_state:
		State.IDLE, State.PATROL:
			sight_cue.text = "?"
			sight_cue.modulate = Color.WHITE
		State.SEARCH:
			sight_cue.text = "?!"
			sight_cue.modulate = Color.ORANGE
		State.CHASE:
			sight_cue.text = "!"
			sight_cue.modulate = Color.YELLOW
		State.ATTACK:
			sight_cue.text = "!!"
			sight_cue.modulate = Color.RED

func _idle_state(_delta: float) -> void:
	enemy.velocity.x = move_toward(enemy.velocity.x, 0, 0.2)
	enemy.velocity.z = move_toward(enemy.velocity.z, 0, 0.2)

func _patrol_state(delta: float) -> void:
	var target_pt: Vector3 = patrol_points[patrol_index]
	enemy.move_to_target(target_pt, delta)

	if enemy.nav_agent.is_navigation_finished():
		patrol_index = (patrol_index + 1) % patrol_points.size()
		change_state(State.IDLE)

func _chase_state(delta: float) -> void:
	if vision and vision.target:
		enemy.move_to_target(vision.target.global_position, delta)

func _attack_state(_delta: float) -> void:
	# Perlambat pergerakan saat menyerang
	enemy.velocity.x = move_toward(enemy.velocity.x, 0, 0.5)
	enemy.velocity.z = move_toward(enemy.velocity.z, 0, 0.5)

	# Serang player setelah cooldown habis
	if vision and vision.target and state_timer <= 0:
		if vision.target.has_method("take_damage"):
			vision.target.take_damage(10.0)
			state_timer = 1.0

func _search_state(delta: float) -> void:
	if _last_known_pos != Vector3.ZERO:
		enemy.move_to_target(_last_known_pos, delta)
