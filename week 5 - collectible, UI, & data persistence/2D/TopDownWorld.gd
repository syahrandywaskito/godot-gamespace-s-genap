extends Node2D

func _ready() -> void:
	# Tunggu satu frame agar semua node (Player, Enemy, HUD) sudah siap
	await get_tree().process_frame
	
	# Load data permainan terakhir jika ada
	GameManager.load_save()
