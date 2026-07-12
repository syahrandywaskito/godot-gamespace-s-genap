extends CanvasLayer

@onready var progress_bar: ProgressBar = $Control/ProgressBar

var tween: Tween

func _ready() -> void:
	SignalBus.boost_setup.connect(_on_boost_setup)
	SignalBus.boost_changed.connect(_on_boost_changed)

func _on_boost_setup(max_boost: float) -> void:
	progress_bar.max_value = max_boost
	progress_bar.value = max_boost

func _on_boost_changed(current_boost: float) -> void:
	if tween and tween.is_valid():
		tween.kill()
	tween = create_tween().set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT)
	tween.tween_property(progress_bar, "value", current_boost, 0.1)
