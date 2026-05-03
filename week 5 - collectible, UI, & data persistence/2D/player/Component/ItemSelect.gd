## Pemilihan Item
##
## digunakan untuk mengontrol pemilihan item dari player
class_name ItemSelect
extends Node

## Daftar senjata yang tersedia.
@export var weapon_list: Array[WeaponStats] = []

## Index senjata yang sedang aktif.
var current_index: int = 0

## Referensi ke WeaponComponent milik Player.
@onready var weapon_component: WeaponComponent = get_parent().get_node("Weapon")

func _ready() -> void:
	# Inisialisasi senjata pertama jika ada
	if weapon_list.size() > 0:
		WeaponChange(0)

## Method API untuk mengganti senjata.
func WeaponChange(new_index: int) -> void:
	# 1. Validasi index
	if new_index < 0 or new_index >= weapon_list.size():
		return
	
	# 2. Update current_index
	current_index = new_index
	
	# 3. Update stats di WeaponComponent
	var active_weapon = weapon_list[current_index]
	if active_weapon and weapon_component:
		weapon_component.stats = active_weapon
	
	# 4. Panggil SignalBus
	SignalBus.weapon_changed.emit(active_weapon)
