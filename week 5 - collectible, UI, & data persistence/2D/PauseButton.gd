extends CanvasLayer

@onready var btn_pause: Button = $Button

func _ready() -> void:
	btn_pause.pressed.connect(GameManager.toggle_pause)
