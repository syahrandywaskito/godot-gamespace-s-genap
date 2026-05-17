extends Node
# SoundPool (Autoload) - Global Object Pooling untuk AudioStreamPlayer

@export var initial_pool_size: int = 15

var _available_players: Array[AudioStreamPlayer] = []
var _active_players: Array[AudioStreamPlayer] = []

func _ready() -> void:
	# Inisialisasi pool dengan jumlah awal
	for i in range(initial_pool_size):
		_create_new_player()

func _create_new_player() -> AudioStreamPlayer:
	var player = AudioStreamPlayer.new()
	add_child(player)
	player.finished.connect(_on_player_finished.bind(player))
	_available_players.append(player)
	return player

## Fungsi utama untuk memainkan suara secara modular
func play_sound(stream: AudioStream, volume_db: float = 0.0, pitch_scale: float = 1.0, randomize_pitch: bool = false, bus: StringName = &"Master") -> AudioStreamPlayer:
	if stream == null:
		push_warning("SoundPool: stream yang diberikan null!")
		return null
		
	var player: AudioStreamPlayer
	
	# Ambil dari inactive/available pool
	if _available_players.is_empty():
		# Expand pool jika sedang terpakai semua
		player = _create_new_player()
		_available_players.pop_back()
	else:
		player = _available_players.pop_back()
		
	_active_players.append(player)
	
	# Randomize pitch agar tidak monoton
	var final_pitch = pitch_scale
	if randomize_pitch:
		final_pitch *= randf_range(0.5, 2)
	
	# Set parameter audio
	player.stream = stream
	player.volume_db = volume_db
	player.pitch_scale = final_pitch
	player.bus = bus
	
	player.play()
	return player

func _on_player_finished(player: AudioStreamPlayer) -> void:
	# Pindahkan dari active kembali ke available saat audio selesai diputar
	_active_players.erase(player)
	_available_players.append(player)
