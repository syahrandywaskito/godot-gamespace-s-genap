class_name StaminaBar
extends ProgressBar

func _ready() -> void:
	SignalBus.stamina_changed.connect(_on_stamina_changed)

func _on_stamina_changed(current_stamina: float) -> void:
	value = current_stamina
