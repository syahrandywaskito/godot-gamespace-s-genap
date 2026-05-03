extends CanvasLayer

@onready var control: Control = $Control
@onready var btn_resume: Button = $Control/Resume
@onready var btn_save: Button = $Control/Save
@onready var btn_quit: Button = $Control/Quit

func _ready() -> void:
	# Hubungkan signal dari GameManager
	GameManager.pause_toggled.connect(_on_pause_toggled)
	
	# Hubungkan signal tombol ke fungsi callable
	btn_resume.pressed.connect(_on_resume_pressed)
	btn_save.pressed.connect(_on_save_pressed)
	btn_quit.pressed.connect(_on_quit_pressed)
	
	# Sembunyikan saat awal
	control.visible = false

func _on_pause_toggled(is_paused: bool) -> void:
	control.visible = is_paused

func _on_resume_pressed() -> void:
	print("UI: Resume Pressed")
	GameManager.resume()

func _on_save_pressed() -> void:
	print("UI: Save Pressed")
	GameManager.save()

func _on_quit_pressed() -> void:
	print("UI: Quit Pressed")
	GameManager.quit_game()
