## Menangani input khusus untuk memicu serangan pemain.
##
## Mendengarkan input klik kiri atau action 'fire' untuk memanggil fungsi attack pada WeaponComponent.
class_name AttackController
extends Node

## Referensi ke WeaponComponent yang akan dipicu.
@export var weapon: WeaponComponent

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("left_click") or event.is_action_pressed("fire"):
		if weapon:
			weapon.attack()
