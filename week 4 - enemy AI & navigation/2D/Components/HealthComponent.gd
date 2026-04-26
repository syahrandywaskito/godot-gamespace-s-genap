## Komponen untuk mengelola kesehatan (HP) objek.
##
## Mengatur nilai kesehatan saat ini, kesehatan maksimal, dan memancarkan sinyal saat terkena damage atau mati.
class_name HealthComponent
extends Node

## Dipancarkan saat kesehatan berubah.
signal health_changed(current_health: float, max_health: float)
## Dipancarkan saat kesehatan mencapai nol.
signal died

## Kesehatan maksimal objek.
@export var max_health: float = 100.0
## Kesehatan objek saat ini.
@onready var current_health: float = max_health

func _ready() -> void:
	health_changed.emit(current_health, max_health)

## Mengurangi kesehatan objek sejumlah [param amount].
func take_damage(amount: float) -> void:
	current_health = clamp(current_health - amount, 0, max_health)
	health_changed.emit(current_health, max_health)
	
	if current_health <= 0:
		died.emit()
