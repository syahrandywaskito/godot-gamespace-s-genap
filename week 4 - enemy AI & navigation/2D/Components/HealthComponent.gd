## Komponen untuk mengelola kesehatan (HP) objek.
##
## Mengatur nilai kesehatan saat ini, kesehatan maksimal, dan memancarkan sinyal saat terkena damage atau mati.
class_name HealthComponent
extends Node

## Dipancarkan saat kesehatan berubah.
signal health_changed(current_health: float, max_health: float)
## Dipancarkan saat kesehatan mencapai nol.
signal died

## health maksimal objek.
@export var max_health: float = 100.0
## health objek saat ini.
var current_health: float = 100.0

func _ready() -> void:
	if GameManager.save_game == null:
		current_health = max_health
		SignalBus.health_setup.emit(max_health)

	health_changed.emit(current_health, max_health)

## Mengurangi kesehatan objek sejumlah [param amount].
func take_damage(amount: float) -> void:
	current_health = clamp(current_health - amount, 0, max_health)
	health_changed.emit(current_health, max_health)
	
	if current_health <= 0:
		died.emit()

## Mengatur kesehatan objek secara langsung (digunakan oleh load system).
func set_health(amount: float) -> void:
	current_health = clamp(amount, 0, max_health)
	health_changed.emit(current_health, max_health)
	# Update signal bus untuk HUD
	SignalBus.health_changed.emit(current_health)
