class_name StaminaComponent
extends Node

@export var max_stamina: float = 100
@export var stamina_consume: float = 5
@export var current_stamina: float = 0
@export var stamina_refill_time: float = 0.5
@export var stamina_gain: float = 7
@export var stamina_timer: Timer = null

func _ready() -> void:
	if GameManager.save_game == null:
		current_stamina = clamp(max_stamina, 0, max_stamina)

	stamina_timer.timeout.connect(_on_stamina_timer_timout)

func get_stamina() -> float:
	return current_stamina

func use_stamina() -> void:
	current_stamina -= stamina_consume
	current_stamina = clamp(current_stamina, 0, max_stamina)
	stamina_timer.stop()

func stamina_refill() -> void:
	if stamina_timer.is_stopped():
		stamina_timer.start(stamina_refill_time)

## Mengatur stamina secara langsung (digunakan oleh load system).
func set_stamina(amount: float) -> void:
	current_stamina = clamp(amount, 0, max_stamina)
	SignalBus.stamina_changed.emit(current_stamina)

func _on_stamina_timer_timout() -> void:
	current_stamina += stamina_gain
	current_stamina = clamp(current_stamina, 0, max_stamina)
	stamina_timer.start(stamina_refill_time)
