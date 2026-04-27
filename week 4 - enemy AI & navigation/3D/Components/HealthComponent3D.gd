## Komponen untuk mengelola kesehatan (HP) objek dalam ruang 3D.
class_name HealthComponent3D
extends Node

signal health_changed(current_health: float, max_health: float)
signal died

@export var max_health: float = 100.0
@onready var current_health: float = max_health

func _ready() -> void:
	health_changed.emit(current_health, max_health)

func take_damage(amount: float) -> void:
	current_health = clamp(current_health - amount, 0, max_health)
	health_changed.emit(current_health, max_health)
	if current_health <= 0:
		died.emit()
