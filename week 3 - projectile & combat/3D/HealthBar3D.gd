class_name HealthBar3D
extends ProgressBar

## Referensi ke pemain. 
## Menggunakan @onready, tetapi akan di-update di _ready untuk keamanan.
@onready var player: CharacterBody3D = get_tree().get_first_node_in_group("Player")

func _ready() -> void:
	# Tunggu 1 frame agar PlayerFPS selesai memanggil add_to_group() di _ready()-nya
	await get_tree().process_frame
	
	# Ambil ulang referensi pemain setelah group terdaftar
	player = get_tree().get_first_node_in_group("Player")
	
	if player:
		if "max_health" in player:
			max_value = player.max_health
		elif player.has_method("get_max_health"):
			max_value = player.get_max_health()
		else:
			max_value = 100 # Fallback jika tidak ditemukan
	else:
		push_warning("HealthBar3D: Player not found in group 'Player'")

func _process(_delta: float) -> void:
	if player:
		if player.has_method("get_current_health"):
			value = player.get_current_health()
		elif "current_health" in player:
			value = player.current_health
