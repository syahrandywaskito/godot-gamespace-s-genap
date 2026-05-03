class_name UIWeaponDisplay
extends Control

## Referensi ke TextureRect untuk ikon senjata.
@onready var weapon_icon: TextureRect = $TextureRect
## Referensi ke Label untuk nama senjata.
@onready var weapon_name_label: Label = $WeaponName

func _ready() -> void:
	# Connect ke signal global
	SignalBus.weapon_changed.connect(_on_weapon_changed)

func _on_weapon_changed(weapon_stats: WeaponStats) -> void:
	if weapon_stats:
		weapon_icon.texture = weapon_stats.weapon_image
		weapon_name_label.text = weapon_stats.weapon_name
