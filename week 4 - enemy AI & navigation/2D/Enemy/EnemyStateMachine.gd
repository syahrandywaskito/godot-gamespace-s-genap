## State Machine sederhana untuk mengatur perilaku AI musuh.
##
## Mengatur transisi antar status: IDLE, CHASE, ATTACK, dan PATROL berdasarkan jarak dan Line of Sight.
class_name EnemyStateMachine
extends Node

## Daftar status yang tersedia.
enum State { IDLE, CHASE, ATTACK, PATROL }

## Status awal saat musuh muncul.
@export var initial_state: State = State.IDLE
## Referensi ke node musuh utama.
@export var enemy: EnemyBase
## Jarak maksimal musuh mendeteksi pemain.
@export var detection_range: float = 300.0
## Jarak maksimal musuh untuk mulai menyerang.
@export var attack_range: float = 60.0
## Daftar titik patroli (opsional). Jika kosong, musuh akan patroli di sekitar posisi awal.
@export var patrol_points: Array[Vector2] = []

@onready var sight_ray: RayCast2D = $"../SightRayCast"
@onready var sight_cue: Label = $"../SightCue"

var current_state: State
var target: Node2D
var start_position: Vector2
var patrol_index: int = 0
var state_timer: float = 0.0

func _ready() -> void:
	current_state = initial_state
	start_position = enemy.global_position
	# Jika tidak ada titik patroli, buat satu titik otomatis
	if patrol_points.is_empty():
		patrol_points.append(start_position)
		patrol_points.append(start_position + Vector2(0, 200))
		#print("patrol point : " + str(patrol_points))

func _physics_process(delta: float) -> void:
	state_timer -= delta
	_update_target()
	_update_state_logic()
	_update_sight_cue()
	
	match current_state:
		State.IDLE:
			_idle_state(delta)
		State.CHASE:
			_chase_state(delta)
		State.ATTACK:
			_attack_state(delta)
		State.PATROL:
			_patrol_state(delta)

## Mengubah status aktif ke [param new_state].
func change_state(new_state: State) -> void:
	if current_state == new_state: return
	current_state = new_state
	state_timer = 2.0 # Reset timer untuk status baru (misal: diam 2 detik)

## Mencari pemain di dalam group "Player".
func _update_target() -> void:
	var players = get_tree().get_nodes_in_group("Player")
	if players.size() > 0:
		target = players[0]
	else:
		target = null

## Mengecek apakah musuh bisa melihat target (Line of Sight).
func _can_see_target() -> bool:
	if target == null: return false
	
	var dist = enemy.global_position.distance_to(target.global_position)
	if dist > detection_range: return false # jika belum masuk maka biarkan
	
	# Arahkan raycast ke target
	sight_ray.target_position = sight_ray.to_local(target.global_position)
	sight_ray.force_raycast_update()
	
	if sight_ray.is_colliding():
		var collider = sight_ray.get_collider()
		return collider.is_in_group("Player")
	
	return false

## Menentukan transisi status berdasarkan jarak dan penglihatan.
func _update_state_logic() -> void:
	var seen = _can_see_target()
	
	if seen:
		var dist = enemy.global_position.distance_to(target.global_position)
		if dist <= attack_range: # masuk ke jarak attack
			change_state(State.ATTACK)
		else:
			change_state(State.CHASE) # tidak masuk ke jarak serang dia akan ngejar
	else:
		# Jika tidak melihat target, kembali ke IDLE/PATROL
		if current_state == State.CHASE or current_state == State.ATTACK:
			change_state(State.IDLE)
		
		# Transisi otomatis IDLE <-> PATROL
		if current_state == State.IDLE and state_timer <= 0:
			change_state(State.PATROL)
		elif current_state == State.PATROL and enemy.nav_agent.is_navigation_finished():
			patrol_index = (patrol_index + 1) % patrol_points.size()
			print("patrol index : " + str(patrol_points[patrol_index]) + " index : " + str(patrol_index))
			change_state(State.IDLE)

func _update_sight_cue() -> void:
	if sight_cue == null: return
	
	match current_state:
		State.IDLE, State.PATROL:
			sight_cue.text = "?"
			sight_cue.modulate = Color.WHITE
		State.CHASE:
			sight_cue.text = "!"
			sight_cue.modulate = Color.YELLOW
		State.ATTACK:
			sight_cue.text = "!!"
			sight_cue.modulate = Color.RED

func _idle_state(_delta: float) -> void:
	enemy.velocity = enemy.velocity.move_toward(Vector2.ZERO, enemy.speed)

func _chase_state(_delta: float) -> void:
	if target and enemy.nav_agent:
		enemy.nav_agent.target_position = target.global_position
		var next_path_pos = enemy.nav_agent.get_next_path_position()
		var dir = (next_path_pos - enemy.global_position).normalized()
		#print("next path pos : " + str(next_path_pos) + " | dir : " + str(dir))
		enemy.velocity = dir * enemy.speed

func _attack_state(_delta: float) -> void:
	enemy.velocity = Vector2.ZERO
	if enemy.weapon and target:
		var dir = (target.global_position - enemy.global_position).normalized()
		enemy.weapon.update_rotation(dir, _delta)
		enemy.weapon.attack()

func _patrol_state(_delta: float) -> void:
	if enemy.nav_agent:
		var target_pos = patrol_points[patrol_index]
		enemy.nav_agent.target_position = target_pos
		var next_path_pos = enemy.nav_agent.get_next_path_position()
		var dir = (next_path_pos - enemy.global_position).normalized()
		enemy.velocity = dir * enemy.speed
