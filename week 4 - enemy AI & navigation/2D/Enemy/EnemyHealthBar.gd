## Menghubungkan visual ProgressBar dengan HealthComponent musuh.
##
## Memperbarui nilai health bar secara otomatis saat sinyal health_changed dipancarkan.
class_name EnemyHealthBar
extends ProgressBar

## Referensi ke HealthComponent yang dipantau.
@export var health_component: HealthComponent

func _ready() -> void:
	if health_component:
		health_component.health_changed.connect(_on_health_changed)
		max_value = health_component.max_health
		value = health_component.current_health

func _on_health_changed(current: float, _max: float) -> void:
	value = current
