extends Node
class_name BoostController

@export var max_fuel: float = 100.0
@export var drain_rate: float = 30.0
@export var refill_rate: float = 15.0
@export var boost_multiplier: float = 1.8
@export var player_path: NodePath = NodePath("..")

var current_fuel: float
var is_boosting: bool = false
var _player: TankPlayer2D

func _ready() -> void:
	current_fuel = max_fuel
	# Tunggu satu frame agar HUD siap connect
	await get_tree().process_frame
	SignalBus.boost_setup.emit(max_fuel)
	SignalBus.boost_changed.emit(current_fuel)
	_player = get_node_or_null(player_path) as TankPlayer2D

func _physics_process(delta: float) -> void:
	if _player == null:
		return

	var moving = _player.velocity != Vector2.ZERO
	var shift_pressed = Input.is_physical_key_pressed(KEY_SHIFT)
	
	is_boosting = shift_pressed and moving and current_fuel > 0.0

	var previous_fuel = current_fuel
	if is_boosting:
		current_fuel = max(current_fuel - drain_rate * delta, 0.0)
		_player.set_boost_multiplier(boost_multiplier)
	else:
		current_fuel = min(current_fuel + refill_rate * delta, max_fuel)
		_player.set_boost_multiplier(1.0)
	
	if not is_equal_approx(current_fuel, previous_fuel):
		SignalBus.boost_changed.emit(current_fuel)
