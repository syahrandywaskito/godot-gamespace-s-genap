class_name HealthBar
extends ProgressBar

func _ready() -> void:
	SignalBus.health_changed.connect(_on_health_changed)
	SignalBus.health_setup.connect(_on_health_setup)

func _on_health_changed(current_health: float) -> void:
	value = current_health

func _on_health_setup(max_health: float) -> void:
	value = max_health
	
