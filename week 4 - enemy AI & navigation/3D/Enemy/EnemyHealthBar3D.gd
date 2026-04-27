## Menghubungkan HealthComponent3D dengan ProgressBar di dalam SubViewport.
class_name EnemyHealthBar3D
extends Node3D

@export var health_component: HealthComponent3D

@onready var progress_bar: ProgressBar = $SubViewport/ProgressBar

func _ready() -> void:
	if health_component:
		health_component.health_changed.connect(_on_health_changed)
		progress_bar.max_value = health_component.max_health
		progress_bar.value = health_component.current_health

func _on_health_changed(current: float, _max: float) -> void:
	progress_bar.value = current
